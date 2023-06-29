// Copyright © 2018-2023 Kaleyra S.p.a. All Rights Reserved.
// See LICENSE for licensing information

/**
 * Screen Share tool configuration
 */
export interface ScreenShareToolConfiguration {

    /**
     * Set to true to enable the in app screen share
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    inApp?: boolean;

    /**
     * Set to true to enable the whole device screen share
     * <br/>
     * <br/>
     * <b><font color="blue">default</font>: false</b>
     */
    wholeDevice?: boolean;
}
