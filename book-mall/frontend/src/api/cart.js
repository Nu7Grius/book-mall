import request from './request'

export function getCartList() {
  return request({
    url: '/cart/list',
    method: 'get'
  })
}

export function getCart(id) {
  return request({
    url: `/cart/${id}`,
    method: 'get'
  })
}

export function updateCart(data) {
  return request({
    url: '/cart',
    method: 'put',
    data
  })
}

export function deleteCart(id) {
  return request({
    url: `/cart/${id}`,
    method: 'delete'
  })
}
