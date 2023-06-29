// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import androidx.room.Dao
import androidx.room.Entity
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.PrimaryKey
import androidx.room.Query
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration

@Entity
data class ConfigurationEntity(
    val plugin: KaleyraVideoConfiguration,
    @PrimaryKey
    val id: Int = 1,
)
@Dao
interface ConfigurationDao {
    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(configurationEntity: ConfigurationEntity)

    @get:Query("SELECT * FROM configurationentity LIMIT 1")
    val configuration: ConfigurationEntity?
}
