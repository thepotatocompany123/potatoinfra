vcl 4.1;

backend default {
    .host = "web-potato";
    .port = "8080";
}

acl admin {
 "127.0.0.1";
}

sub vcl_recv {
    set req.backend_hint = default;

    if (req.http.Upgrade ~ "(?i)websocket") {
        return (pipe);
    }

    if ( req.url ~ "^/connectivitytester" && !(client.ip ~ admin) ) {
        return(synth(403, "Only localhost is allowed."));
    }
}

sub vcl_pipe {
    if (req.http.Upgrade) {
        set bereq.http.Upgrade = req.http.Upgrade;
        set bereq.http.Connection = req.http.Connection;
    }
    return (pipe);
}
