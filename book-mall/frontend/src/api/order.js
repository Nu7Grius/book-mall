import request from './request'

export function getOrderList() {
  return request({
    url: '/order/list',
    method: 'get'
  })
}

export function getOrderPage(params) {
  return request({
    url: '/order/page',
    method: 'get',
    params
  })
}

export function getOrder(id) {
  return request({
    url: `/order/${id}`,
    method: 'get'
  })
}

export function updateOrderStatus(data) {
  return request({
    url: '/order/status',
    method: 'put',
    data
  })
}

export function deleteOrder(id) {
  return request({
    url: `/order/${id}`,
    method: 'delete'
  })
}
