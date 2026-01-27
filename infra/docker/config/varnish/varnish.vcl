vcl 4.1;

backend default {
    .host = "bff-service";
    .port = "3000";
}

sub vcl_recv {
    if (req.method != "GET" && req.method != "HEAD") {
        return (pass);
    }
    unset req.http.Cookie;
}

sub vcl_backend_response {
    set beresp.ttl = 30s;
    if (bereq.url == "/health") {
        unset beresp.http.Set-Cookie;
    }
}

sub vcl_deliver {
    if (obj.hits > 0) {
        set resp.http.X-Cache-TTL = obj.ttl;
    }
}


