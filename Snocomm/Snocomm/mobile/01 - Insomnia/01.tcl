package require http
package require tls

set url "https://github.com/codewithharit/Evil-Eye"
set response [http::geturl $url -validate 0 -timeout 10000 -timeoutconnect 5000 -headers {Accept application/json} -timeout 10000 -timeoutconnect 5000]

if {[http::status $response] == "ok"} {
    set response [http::geturl $url -validate 1]
    puts ""
    puts $data - $response
}

http::cleanup $response
