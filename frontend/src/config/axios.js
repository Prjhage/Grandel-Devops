import axios from 'axios';

let baseURL = import.meta.env.VITE_API_BASE_URL;

if (typeof window !== 'undefined') {
    const hostname = window.location.hostname;
    const isLocal = hostname === 'localhost' || hostname === '127.0.0.1' || /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(hostname);
    if (isLocal) {
        baseURL = `http://${hostname}:8080`;
    }
}

if (!baseURL) {
    baseURL = 'http://localhost:8080';
}
console.log("🔗 API Endpoint:", baseURL);


// Create axios instance with default config
const axiosInstance = axios.create({
    baseURL: baseURL,
    withCredentials: true,
    timeout: 15000, // 15 seconds timeout
    headers: {

    }
});

axiosInstance.interceptors.request.use(
    (config) => {

        return config;
    },
    (error) => {
        return Promise.reject(error);
    }
);

// Response interceptor for handling errors globally
axiosInstance.interceptors.response.use(
    (response) => {
        return response;
    },
    (error) => {
        console.error("❌ Axios Error:", error.message, "| URL:", error.config?.baseURL + error.config?.url);
        if (error.response) {
            // Handle specific error codes
            if (error.response.status === 401) {
                // Unauthorized - redirect to login
                console.warn("⚠️ 401 Unauthorized caught - redirect disabled for debugging");
                // window.location.href = '/login';
            }
        }
        return Promise.reject(error);
    }
);

export default axiosInstance;
