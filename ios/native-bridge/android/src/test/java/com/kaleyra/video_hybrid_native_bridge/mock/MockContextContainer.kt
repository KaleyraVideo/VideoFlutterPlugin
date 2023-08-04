// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

package com.kaleyra.video_hybrid_native_bridge.mock

import android.content.Context
import com.kaleyra.video_hybrid_native_bridge.ContextContainer
import io.mockk.mockk

class MockContextContainer(override val context: Context = mockk(relaxed = true)) : ContextContainer
