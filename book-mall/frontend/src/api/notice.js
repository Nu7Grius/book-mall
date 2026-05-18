import request from './request'

export function getNoticeList() {
  return request({
    url: '/notice/list',
    method: 'get'
  })
}

export function getNoticePage(params) {
  return request({
    url: '/notice/page',
    method: 'get',
    params
  })
}

export function getNotice(id) {
  return request({
    url: `/notice/${id}`,
    method: 'get'
  })
}

export function addNotice(data) {
  return request({
    url: '/notice',
    method: 'post',
    data
  })
}

export function updateNotice(data) {
  return request({
    url: '/notice',
    method: 'put',
    data
  })
}

export function deleteNotice(id) {
  return request({
    url: `/notice/${id}`,
    method: 'delete'
  })
}
