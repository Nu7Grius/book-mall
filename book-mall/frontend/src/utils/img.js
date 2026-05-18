const BASE_API = process.env.VUE_APP_BASE_API || 'http://localhost:8080';

export function getImageUrl(path) {
  if (!path) return '';
  if (path.startsWith('data:')) return path;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return BASE_API + path;
}

export function getBookCoverUrl(coverImage) {
  return getImageUrl(coverImage);
}

export function getAvatarUrl(avatar) {
  return getImageUrl(avatar);
}

export function getLogoUrl(logo) {
  return getImageUrl(logo);
}

export { BASE_API };
export default { getImageUrl, getBookCoverUrl, getAvatarUrl, getLogoUrl, BASE_API };
