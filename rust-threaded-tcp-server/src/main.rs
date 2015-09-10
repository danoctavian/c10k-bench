#![feature(io)]
extern crate threadpool;

use threadpool::ThreadPool;

use std::net::{TcpListener, TcpStream};
use std::io::Read;
use std::io::Write;
use std::io;

fn main() {
  println!("running server..");

  let listener = TcpListener::bind("127.0.0.1:4000").unwrap();


  fn handle_client(mut stream: TcpStream) -> io::Result<()> {
      let mut out = stream.try_clone();
      match out {
        Ok(mut sink) => {
          // tee doesn't work correctly
          //stream.tee(sink);

          let mut buf = [0u8; 1024 * 16];
          loop {
              let size = try!(stream.read(&mut buf));
              if size == 0 {
                  /* eof */
                  break;
              }
              try!(sink.write_all(&mut buf[0..size]))
          }
        }
        Err(e) => { /* cloning failed */ }

      }

      Ok(())
  }

  let pool = ThreadPool::new(1000);

  // accept connections and process them, spawning a new thread for each one
  for stream in listener.incoming() {
      match stream {
          Ok(stream) => {
              pool.execute(move|| {
                let r = handle_client(stream);
              });
          }
          Err(e) => { /* connection failed */ }
      }
  }

  // close the socket server
  drop(listener);
}
