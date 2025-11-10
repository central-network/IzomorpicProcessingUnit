from aioquic.asyncio import QuicConnectionProtocol, serve
from aioquic.h3.connection import H3_ALPN, H3Connection
from aioquic.h3.events import H3Event, HeadersReceived, WebTransportStreamDataReceived, DatagramReceived, PushPromiseReceived, DataReceived
from aioquic.quic.events import ProtocolNegotiated, StreamReset, QuicEvent, HandshakeCompleted, PingAcknowledged, StopSendingReceived, StreamDataReceived, ConnectionTerminated
from aioquic.quic.configuration import QuicConfiguration
from typing import Dict, Optional
import asyncio

dagiticilar = {}
class Dagitici:
    def __init__(self, http: H3Connection, stream_id, dagitici_id) -> None:
        self._dagitici_id   = dagitici_id
        self._session_id    = stream_id  # Bu WebTransport session ID
        self._stream_id     = stream_id
        self._streams       = {}  # Her istemci için stream tutmak için
        self._http          = http
        dagiticilar[dagitici_id] = self
        print(f"dagitici Stream: {stream_id} Dagitici: {dagitici_id}: {type(dagiticilar[dagitici_id])}")
    
    def handle(self, event: H3Event) -> None:
        if  isinstance(event, DataReceived):
            print(f"dagitici DataReceived ({len(event.data)}): {event.stream_id!r}")

        if  isinstance(event, PushPromiseReceived):
            print(f"dagitici PushPromiseReceived: {event.stream_id!r}")

        if  isinstance(event, DatagramReceived):
            print(f"dagitici Received datagram: {event.data!r}")

        if  isinstance(event, HeadersReceived):
            print(f"dagitici HeadersReceived: {event.stream_id!r}")
            
        if  isinstance(event, WebTransportStreamDataReceived):
            print(f"dagitici WebTransportStreamDataReceived:")

class Istemci:
    def __init__(self, http: H3Connection, stream_id, dagitici_id, istemci_id) -> None:
        self._dagitici_id   = dagitici_id
        self._session_id    = stream_id  # Bu WebTransport session ID
        self._istemci_id    = istemci_id
        self._stream_id     = stream_id
        self._http          = http

        print(f"istemci Stream: {stream_id} Dagitici: {dagitici_id}: {type(dagiticilar.get(dagitici_id))} <-- Istemci: {istemci_id}")

    def handle(self, event: H3Event) -> None:
        if  isinstance(event, DataReceived):
            print(f"istemci DataReceived ({len(event.data)}): {event.stream_id!r}")

        if  isinstance(event, PushPromiseReceived):
            print(f"istemci PushPromiseReceived: {event.stream_id!r}")

        if  isinstance(event, DatagramReceived):
            print(f"istemci DatagramReceived: {event.data!r}")

        if  isinstance(event, HeadersReceived):
            print(f"istemci HeadersReceived: {event.stream_id!r}")

        if  isinstance(event, WebTransportStreamDataReceived):
            print(f"istemci WebTransportStreamDataReceived:")


class WebTransportProtocol(QuicConnectionProtocol):

    def quic_event_received(self, event: QuicEvent) -> None:

        if  isinstance(event, ProtocolNegotiated):
            print(f"ProtocolNegotiated!")
            self._http = H3Connection(self._quic, enable_webtransport=True)

        elif isinstance(event, HandshakeCompleted):
            print(f"HandshakeCompleted!")

        elif isinstance(event, StreamDataReceived):
            print(f"StreamDataReceived!")

        elif isinstance(event, StopSendingReceived):
            print(f"StopSendingReceived!")

        elif isinstance(event, PingAcknowledged):
            print(f"PingAcknowledged!")

        elif isinstance(event, ConnectionTerminated):
            print(f"ConnectionTerminated!")

        elif isinstance(event, StreamReset):
            if  self._handler is not None:
                self._handler.stream_closed(event.stream_id)

        if self._http is not None:
            for event in self._http.handle_event(event):
                if isinstance(event, HeadersReceived):
                    headers = {}
                    for header, value in event.headers:
                        headers[header] = value

                    if headers.get(b":method") == b"CONNECT":
                        self.bind(event.stream_id, headers)
                    else:
                        self.send(event.stream_id, 400, end_stream=True)

                if isinstance(event, WebTransportStreamDataReceived):
                    if isinstance(self._handler, Istemci):
                        dagitici = dagiticilar.get(self._handler._dagitici_id)
                        if dagitici:
                            if self._handler._istemci_id not in dagitici._streams:
                                sid = dagitici._http.create_webtransport_stream(dagitici._session_id)
                                dagitici._streams[self._handler._istemci_id] = sid
                                print(f"Stream açıldı: {sid}")
                            
                            sid = dagitici._streams[self._handler._istemci_id]
                            self._http._quic.send_stream_data(sid, event.data)
                            print(f"Veri yazıldı: {event.data}")

                if self._handler:
                    self._handler.handle(event)
                    

    def bind(self, stream_id: int, headers: Dict[bytes, bytes]) -> None:
        path = headers.get(b":path").decode().split("/?")[1]

        if  ":" in path:
            dagitici_id = path.split(":")[0]
            istemci_id  = path.split(":")[1]
            self._handler = Istemci(self._http, stream_id, dagitici_id, istemci_id)

        else:
            dagitici_id = path
            self._handler = Dagitici(self._http, stream_id, dagitici_id)

        self.send(stream_id, 200)

    def send(self, stream_id: int, status_code: int, end_stream=False) -> None:
        headers = [(b":status", str(status_code).encode())]
        if status_code == 200: headers.append((b"sec-webtransport-http3-draft", b"draft02"))
        self._http.send_headers(stream_id=stream_id, headers=headers, end_stream=end_stream)


config      = QuicConfiguration(alpn_protocols=H3_ALPN, is_client=False)
loop        = asyncio.new_event_loop()

config.load_cert_chain("/opt/homebrew/etc/nginx/cert.pem", "/opt/homebrew/etc/nginx/key.pem")
loop.run_until_complete(serve("cen.net", 4433, configuration=config, create_protocol=WebTransportProtocol))

try: loop.run_forever()
except KeyboardInterrupt: pass