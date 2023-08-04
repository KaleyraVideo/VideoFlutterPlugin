// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import android.content.Context
import androidx.room.Database
import androidx.room.Room
import androidx.room.RoomDatabase
import androidx.room.TypeConverters


/**
 *
 * @author kristiyan
 */
@Database(entities = [UserDetailsEntity::class, ConfigurationEntity::class, ConnectedUserEntity::class], version = 2, exportSchema = false)
@TypeConverters(Converters::class)
abstract class VideoHybridBridgeRepository : RoomDatabase() {

    companion object {

        private var instance: VideoHybridBridgeRepository? = null

        fun getInstance(context: Context): VideoHybridBridgeRepository = synchronized(VideoHybridBridgeRepository::class) {
            return instance ?: Room.databaseBuilder(
              context.applicationContext,
              VideoHybridBridgeRepository::class.java, "kaleyra_video_hybrid_bridge_repository.db"
            )
                .fallbackToDestructiveMigration()
                .build()
                .apply { instance = this }
        }
    }

    abstract fun userDao(): UserDetailsDao
    abstract fun configurationDao(): ConfigurationDao
    abstract fun connectedUserDao(): ConnectedUserDao
}
