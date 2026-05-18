import request from './request'

export function getAddressList() {
  return request({
    url: '/address/list',
    method: 'get'
  })
}

export function getAddress(id) {
  return request({
    url: `/address/${id}`,
    method: 'get'
  })
}

export function deleteAddress(id) {
  return request({
    url: `/address/${id}`,
    method: 'delete'
  })
}
