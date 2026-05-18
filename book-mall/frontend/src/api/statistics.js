import request from './request'

export function getStatisticsOverview() {
  return request({
    url: '/statistics/overview',
    method: 'get'
  })
}

export function getHotBooks(limit = 10) {
  return request({
    url: '/book/hot',
    method: 'get',
    params: { limit }
  })
}

export function getNoticeList() {
  return request({
    url: '/notice/list',
    method: 'get'
  })
}

export function getHotMerchants(limit = 5) {
  return request({
    url: '/merchant/hot',
    method: 'get',
    params: { limit }
  })
}
