// ==UserScript==
// @name         Demand
// @namespace    puyo/demand
// @license      Creative Commons BY-NC-SA
// @encoding     utf-8
// @version      0.2
// @description  Skip the ads
// @author       puyo
// @include      https://www.sbs.com.au/ondemand/video/*
// @require      https://jpillora.com/xhook/dist/xhook.js
// @grant        none
// @run-at       document-start
// ==/UserScript==

(function() {
    'use strict';

    const skip = [
        '^#EXTINF:[^\n]+,\\nhttps://redirector\\.googlevideo\\.com',
        '.*?',
        '(',
        '^#EXT-X-KEY:[^\n]*sbslive',
        '|',
        '^#EXT-X-KEY:[^\n]*https://sbsvoddai',
        ')',
    ]

    const skipRe = new RegExp(skip.join(''), 'gms')

    function filterPlaylist(text) {
        return text.replace(skipRe, function (_match, group, _offset) { return group })
    }

    xhook.after(function(request, response) {
        if (request.url.match(/\.m3u8$/)) {
            // remove ad videos
            response.data = response.text = filterPlaylist(response.text)
        } else if (request.url.match(/time-events\.json$/)) {
            // remove ad marks on progress meter
            const data = JSON.parse(response.data)
            data.ads = {}
            data.breaks = {}
            data.cuepoints = []
            data.times = {}
            response.data = response.text = JSON.stringify(data)
        }
    });
})();

