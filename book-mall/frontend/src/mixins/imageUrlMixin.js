import { getImageUrl as _getImageUrl } from '@/utils/imageUrl'

export default {
  methods: {
    getImageUrl(path) {
      return _getImageUrl(path)
    }
  }
}
