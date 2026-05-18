import request from "../utils/request.js";

export function getCommentsByBookId(bookId) {
  return request({
    url: `/comment/book/${bookId}`,
    method: "GET",
  });
}

export function getCommentsByUserId(userId) {
  return request({
    url: `/comment/user/${userId}`,
    method: "GET",
  });
}

export function addComment(data) {
  return request({
    url: "/comment",
    method: "POST",
    data,
  });
}

export function deleteComment(id) {
  return request({
    url: `/comment/${id}`,
    method: "DELETE",
  });
}

export function getCommentStats(bookId) {
  return request({
    url: `/comment/stats/${bookId}`,
    method: "GET",
  });
}
