import request from './request'

export function applyRefund(data) {
    return request.post('/refund/apply-by-item', data)
}

export function getUserRefundList(params) {
    return request.get('/refund/user/list', { params })
}

export function getMerchantRefundList(params) {
    return request.get('/refund/merchant/list', { params })
}

export function processRefund(data) {
    return request.post('/refund/process', data)
}

export function getRefundDetail(id) {
    return request.get(`/refund/detail/${id}`)
}
