export async function publishWebRTCOffer(jwt:string, pc:RTCPeerConnection) {
    const stream = await navigator.mediaDevices.getUserMedia({
        video: true,
        audio: true
    });
    stream.getTracks().forEach(track => pc.addTrack(track, stream));
    pc.getTransceivers().forEach(t => {
    t.direction = "sendonly"

    if (t.sender.track?.kind === "video") {
        const caps = RTCRtpSender.getCapabilities("video")
        const h264 = caps.codecs.filter(c =>
        c.mimeType === "video/H264" &&
        c.sdpFmtpLine?.includes("packetization-mode=1") &&
        c.sdpFmtpLine?.includes("profile-level-id=42")
        )
        t.setCodecPreferences(h264)
    }
    })
    const offer = await pc.createOffer();
    await pc.setLocalDescription(offer);
    const response = await fetch(
        "https://sugarfever.ddns.net/control/whip",
        {
            method: "POST",
            headers: {
            "Content-Type": "application/sdp",
            Authorization: `Bearer ${jwt}`,
            },
            body: offer.sdp
        }
    );

    if (!response.ok) {
        const text = await response.text();
        throw new Error(`WebRTC signaling failed: ${response.status} ${text}`);
    }

    const answerSDP = await response.text();
    await pc.setRemoteDescription({
        type: "answer",
        sdp: answerSDP
    });
}