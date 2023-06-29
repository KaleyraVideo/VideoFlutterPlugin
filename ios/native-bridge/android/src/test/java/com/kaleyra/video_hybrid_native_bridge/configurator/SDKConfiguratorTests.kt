// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.configurator

import com.bandyer.android_sdk.client.BandyerSDKInstance
import com.kaleyra.video_hybrid_native_bridge.KaleyraVideoConfiguration
import com.kaleyra.video_hybrid_native_bridge.CreateCallOptionsProxy
import com.kaleyra.video_hybrid_native_bridge.Environment
import com.kaleyra.video_hybrid_native_bridge.Region
import com.kaleyra.video_hybrid_native_bridge.mock.MockVideoHybridBridgeRepository
import com.kaleyra.video_hybrid_native_bridge.repository.ConfigurationEntity
import com.kaleyra.video_hybrid_native_bridge.utils.RandomRunner
import io.mockk.mockk
import io.mockk.verify
import kotlinx.coroutines.CoroutineName
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.test.advanceUntilIdle
import kotlinx.coroutines.test.runTest
import org.junit.Assert.assertEquals
import org.junit.Test
import org.junit.runner.RunWith

@OptIn(ExperimentalCoroutinesApi::class)
@RunWith(RandomRunner::class)
class SDKConfiguratorTests {

    private val repository = MockVideoHybridBridgeRepository()
    private val sdk = mockk<BandyerSDKInstance>(relaxed = true)
    private val callOptionsProxy = CreateCallOptionsProxy()
    private val conf = KaleyraVideoConfiguration(appID = "appId", environment = Environment("env"), region = Region("region"))

    @Test
    fun loadFromRepositoryAtInit() = runTest(CoroutineName("io")) {
        val repository = MockVideoHybridBridgeRepository(configuration = ConfigurationEntity(conf))
        val configurator = VideoSDKConfigurator(sdk, callOptionsProxy, repository, this)
        advanceUntilIdle()
        with(repository.configurationDao) {
            verify(exactly = 1) { configuration }
        }
        assertEquals(conf, configurator.lastConfiguration)
    }

    @Test
    fun configure() = runTest(CoroutineName("io")) {
        val configurator = VideoSDKConfigurator(sdk, callOptionsProxy, repository, this)
        configurator.configureBridge(conf)
        advanceUntilIdle()
        verify { sdk.configure(any()) }
        with(repository.configurationDao) {
            verify { insert(any()) }
        }
        assertEquals(conf, configurator.lastConfiguration)
    }

    @Test
    fun reset() = runTest(CoroutineName("io")) {
        val configurator = VideoSDKConfigurator(sdk, callOptionsProxy, repository, this)
        configurator.configureBridge(conf)
        configurator.reset()
        advanceUntilIdle()
        verify { sdk.reset() }
        assertEquals(true, repository.clearAllTables)
        assertEquals(null, configurator.lastConfiguration)
    }
}
