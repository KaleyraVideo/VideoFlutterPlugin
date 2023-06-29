// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import androidx.room.Dao
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query

@Entity
data class ConnectedUserEntity(
    @PrimaryKey
    val user: String
)

@Dao
interface ConnectedUserDao {

    @get:Query("SELECT * FROM connecteduserentity LIMIT 1")
    val user: ConnectedUserEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(connectedUserEntity: ConnectedUserEntity)

    @Query("DELETE FROM connecteduserentity")
    fun clear()
}
