import app/web
import gleam/http
import gleam/string_tree
import wisp.{type Request, type Response}

pub fn handle_request(req: Request) -> Response {
  use req <- web.middleware(req)

  case wisp.path_segments(req) {
    [] -> home_page(req)
    ["comments"] -> comments(req)
    ["comments", id] -> show_comment(req, id)
    _ -> wisp.not_found()
  }
}

fn home_page(req: Request) -> Response {
  use <- wisp.require_method(req, http.Get)
  let html = string_tree.from_string("Hello, Joe!")
  wisp.ok()
  |> wisp.html_body(html)
}

fn comments(req: Request) -> Response {
  case req.method {
    http.Get -> list_comments()
    http.Post -> create_comment(req)
    _ -> wisp.method_not_allowed([http.Get, http.Post])
  }
}

fn list_comments() -> Response {
  let html = string_tree.from_string("Comments!")
  wisp.ok()
  |> wisp.html_body(html)
}

fn create_comment(_req: Request) -> Response {
  let html = string_tree.from_string("Created")
  wisp.created()
  |> wisp.html_body(html)
}

fn show_comment(req: Request, id: String) -> Response {
  use <- wisp.require_method(req, http.Get)
  let html = string_tree.from_string("Comment with id " <> id)
  wisp.ok()
  |> wisp.html_body(html)
}
