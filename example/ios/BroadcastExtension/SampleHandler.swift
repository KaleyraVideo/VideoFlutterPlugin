// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import ReplayKit
import BandyerBroadcastExtension

class SampleHandler: RPBroadcastSampleHandler {

  override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
      BroadcastExtension.instance.start(appGroupIdentifier: "group.com.kaleyraVideo.AppName", setupInfo: nil) { [unowned self] error in
          self.finishBroadcastWithError(error)
      }
  }

  override func broadcastPaused() {
      BroadcastExtension.instance.pause()
  }

  override func broadcastResumed() {
      BroadcastExtension.instance.resume()
  }

  override func broadcastFinished() {
      BroadcastExtension.instance.finish()
  }

  override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
      BroadcastExtension.instance.process(sampleBuffer: sampleBuffer, ofType: sampleBufferType)
  }
}
