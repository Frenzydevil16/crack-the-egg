/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// This object will be exposed on the window to be called from Godot.
// It interfaces with the YouTube Playables Game SDK.
window.YTGameSDK_Godot = {
    _hasFirstFrameReady: false,
    _hasGameReady: false,

    // Helper to check if we are in the Playables environment or Test Suite.
    _inEnv: function() {
        return typeof ytgame !== 'undefined';
    },

    getSDKVersion: function() {
        return (typeof ytgame !== 'undefined' && ytgame.SDK_VERSION) ? ytgame.SDK_VERSION : "N/A";
    },

    sendScore: function(score) {
        if (typeof ytgame !== 'undefined' && ytgame.engagement && typeof ytgame.engagement.sendScore === 'function') {
            ytgame.engagement.sendScore({ value: Math.floor(score) });
        }
    },

    firstFrameReady: function() {
        if (this._hasFirstFrameReady) {
            return;
        }
        this._hasFirstFrameReady = true;
        if (typeof ytgame !== 'undefined' && ytgame.game && typeof ytgame.game.firstFrameReady === 'function') {
            console.log("[YTGameSDK] Invoking ytgame.game.firstFrameReady()");
            ytgame.game.firstFrameReady();
        }
    },

    gameReady: function() {
        if (this._hasGameReady) {
            return;
        }
        // Strict Playables requirement: firstFrameReady MUST always be called before gameReady
        if (!this._hasFirstFrameReady) {
            console.log("[YTGameSDK] Ensuring firstFrameReady() is called before gameReady()");
            this.firstFrameReady();
        }
        this._hasGameReady = true;
        if (typeof ytgame !== 'undefined' && ytgame.game && typeof ytgame.game.gameReady === 'function') {
            console.log("[YTGameSDK] Invoking ytgame.game.gameReady()");
            ytgame.game.gameReady();
        }
    },

    saveData: function(playableSaveData) {
        if (this._inEnv()) {
            ytgame.game.saveData(playableSaveData).then(() => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onSaveSuccess === 'function') {
                    window.GodotYTCallbacks.onSaveSuccess();
                }
            }, (e) => {
                if (typeof ytgame.health !== 'undefined' && typeof ytgame.health.logError === 'function') {
                    ytgame.health.logError();
                }
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onSaveFailed === 'function') {
                    window.GodotYTCallbacks.onSaveFailed(e ? e.toString() : "Unknown save error");
                }
            });
        } else {
            if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onSaveFailed === 'function') {
                window.GodotYTCallbacks.onSaveFailed("Not in Playables Environment.");
            }
        }
    },

    loadData: function() {
        if (this._inEnv()) {
            ytgame.game.loadData().then((data) => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onLoadDataReceived === 'function') {
                    window.GodotYTCallbacks.onLoadDataReceived(data ? data.toString() : "");
                }
            }, (e) => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onLoadDataReceived === 'function') {
                    window.GodotYTCallbacks.onLoadDataReceived("");
                }
            });
        } else {
            if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onLoadDataReceived === 'function') {
                window.GodotYTCallbacks.onLoadDataReceived("");
            }
        }
    },

    logError: function(errorMessage) {
        console.error(errorMessage);
        if (this._inEnv() && typeof ytgame.health !== 'undefined' && typeof ytgame.health.logError === 'function') {
            ytgame.health.logError();
        }
    },

    logWarning: function(warningMessage) {
        console.warn(warningMessage);
        if (this._inEnv() && typeof ytgame.health !== 'undefined' && typeof ytgame.health.logWarning === 'function') {
            ytgame.health.logWarning();
        }
    },

    isAudioEnabled: function() {
        return this._inEnv() ? ytgame.system.isAudioEnabled() : true;
    },

    inPlayablesEnv: function() {
        return this._inEnv();
    },

    requestInterstitialAd: function() {
        if (this._inEnv()) {
            ytgame.ads.requestInterstitialAd().then(() => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onAdSuccess === 'function') {
                    window.GodotYTCallbacks.onAdSuccess();
                }
            }, (e) => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onAdFailed === 'function') {
                    window.GodotYTCallbacks.onAdFailed(e ? e.toString() : "Ad failed");
                }
            });
        } else {
            if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onAdFailed === 'function') {
                window.GodotYTCallbacks.onAdFailed("Not in Playables Environment.");
            }
        }
    },

    // Called from Godot to register listeners with the YouTube SDK
    setAllCallbacks: function() {
        if (this._inEnv()) {
            ytgame.system.onAudioEnabledChange((isAudioEnabled) => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onAudioEnabledChanged === 'function') {
                    window.GodotYTCallbacks.onAudioEnabledChanged(isAudioEnabled);
                }
            });
            ytgame.system.onPause(() => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onGamePaused === 'function') {
                    window.GodotYTCallbacks.onGamePaused();
                }
            });
            ytgame.system.onResume(() => {
                if (window.GodotYTCallbacks && typeof window.GodotYTCallbacks.onGameResumed === 'function') {
                    window.GodotYTCallbacks.onGameResumed();
                }
            });
        }
    }
};
