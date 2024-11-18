// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import androidx.room.DatabaseConfiguration
import androidx.room.InvalidationTracker
import androidx.sqlite.db.SupportSQLiteOpenHelper
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.Environment
import com.kaleyra.video_hybrid_native_bridge.Region
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationDao
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationEntity
import com.kaleyra.video_hybrid_native_bridge.repository.ConnectedUserDao
import com.kaleyra.video_hybrid_native_bridge.repository.ConnectedUserEntity
import com.kaleyra.video_hybrid_native_bridge.repository.VideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsDao
import com.kaleyra.video_hybrid_native_bridge.repository.UserDetailsEntity
import io.mockk.every
import io.mockk.mockk
import org.junit.Assert

class MockVideoHybridBridgeRepository(
    val mockList: MutableList<UserDetailsEntity> = mutableListOf<UserDetailsEntity>(),
    var connectedUser: ConnectedUserEntity? = ConnectedUserEntity("ciao"),
    var configuration: ConfigurationEntity? = ConfigurationEntity(KaleyraVideoConfiguration("appId", Environment("env"), region = Region("eu")))
) : VideoHybridBridgeRepository() {

    val userDao = mockk<UserDetailsDao> {
        every { all } returns mockList
        every { getUserDetailsEntity(any()) } answers {
            mockList.firstOrNull { it.userID == arg(0) }
        }
        every { insert(any()) } answers {
            mockList.addAll(arg(0))
        }
        every { clear() } answers {
            mockList.clear()
        }
    }

    val connectedUserDao = mockk<ConnectedUserDao> {
        every { insert(any()) } answers {
            connectedUser = arg<ConnectedUserEntity>(0)
        }
        every { clear() } answers {
            connectedUser = null
        }
        every { user } returns connectedUser!!
    }

    val configurationDao = mockk<ConfigurationDao> {
        every { insert(any()) } answers {
            this@MockVideoHybridBridgeRepository.configuration = arg<ConfigurationEntity>(0)
        }
        every { configuration } returns this@MockVideoHybridBridgeRepository.configuration!!
    }

    var clearAllTables = false
        private set

    override fun userDao(): UserDetailsDao {
        assertIoThread()
        return userDao
    }

    override fun configurationDao(): ConfigurationDao {
        assertIoThread()
        return configurationDao
    }

    override fun connectedUserDao(): ConnectedUserDao {
        assertIoThread()
        return connectedUserDao
    }

    override fun createOpenHelper(config: DatabaseConfiguration): SupportSQLiteOpenHelper = mockk()

    override fun createInvalidationTracker(): InvalidationTracker = mockk()

    override fun clearAllTables() {
        clearAllTables = true
    }

    private fun assertIoThread() = Assert.assertTrue("Expected to be called on IO but called on=${Thread.currentThread().name}", Thread.currentThread().name.contains("io"))
}
