extern crate coio;

use std::io::{Read, Write};

use coio::net::TcpListener;
use coio::{spawn, run};

fn main() {
    // Spawn a coroutine for accepting new connections
    spawn(move|| {
        let acceptor = TcpListener::bind("127.0.0.1:4000").unwrap();
        println!("Waiting for connection ...");

        for stream in acceptor.incoming() {
            let mut stream = stream.unwrap();

            //println!("Got connection from {:?}", stream.peer_addr().unwrap());

            // Spawn a new coroutine to handle the connection
            spawn(move|| {
                let mut buf = [0; 1024];

                loop {
                    match stream.read(&mut buf) {
                        Ok(0) => {
                            //println!("EOF");
                            break;
                        },
                        Ok(len) => {
                            //println!("Read {} bytes, echo back", len);
                            stream.write_all(&buf[0..len]).unwrap();
                        },
                        Err(err) => {
                            //pprintln!("Error occurs: {:?}", err);
                            break;
                        }
                    }
                }

                //println!("Client closed");
            });
        }
    });

    // Schedule with 4 threads
    run(4);
}