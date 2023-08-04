// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

import {ScreenShareToolConfiguration} from "./ScreenShareToolConfiguration";
import {ChatToolConfiguration} from "./ChatToolConfiguration";

/**
 * Video Module Tools
 */
export interface Tools {
    /**
     * Set to true to enable the file sharing feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    fileShare?: boolean;

    /**
     * Set to enable the screen sharing feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: no screen share</b>
     */
    screenShare?: ScreenShareToolConfiguration;

    /**
     * Set to enable the chat feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: no chat</b>
     */
    chat?: ChatToolConfiguration;

    /**
     * Set to true to enable the whiteboard feature
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    whiteboard?: boolean;

    /**
     * Set to true to enable the feedback request after a call ends.
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    feedback?: boolean;
}
