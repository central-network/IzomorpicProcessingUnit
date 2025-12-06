export async function getLocalIP4AddressOverRTC () {
    return new Promise( ( resolve, reject ) => 
        new RTCPeerConnection().createOffer( ({sdp}) => {
            resolve(sdp.match(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/g))
        }, reject )
    )
}

export function generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        const r = Math.random() * 16 | 0, v = c === 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}