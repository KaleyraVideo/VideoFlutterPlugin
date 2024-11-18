// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.repository

import androidx.room.*

@Dao
interface UserDetailsDao {
    @get:Query("SELECT * FROM userdetailsentity")
    val all: List<UserDetailsEntity>

    @Query("SELECT * FROM userdetailsentity WHERE userID = :userAlias LIMIT 1")
    fun getUserDetailsEntity(userAlias: String): UserDetailsEntity?

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    fun insert(userDetailsEntities: List<UserDetailsEntity>)

    @Query("DELETE FROM userdetailsentity")
    fun clear()
}
