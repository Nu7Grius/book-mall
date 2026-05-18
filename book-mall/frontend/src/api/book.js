import request from './request'

export function getBookList(params) {
  return request({
    url: '/book/list',
    method: 'get',
    params
  })
}

export function getBookPage(params) {
  return request({
    url: '/book/page',
    method: 'get',
    params
  })
}

export function getBookById(id) {
  return request({
    url: `/book/${id}`,
    method: 'get'
  })
}

export function addBook(data) {
  return request({
    url: '/book/add',
    method: 'post',
    data
  })
}

export function updateBook(data) {
  return request({
    url: '/book/update',
    method: 'put',
    data
  })
}

export function deleteBook(id) {
  return request({
    url: `/book/${id}`,
    method: 'delete'
  })
}
