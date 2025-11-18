// auth.api.ts

import type { LoginRequest, LoginResponse } from "@/types/auth.type";
import { publicApi } from "../common/axiosInstance";
import { API_ROUTES } from "../common/apiMappingPattern";
import type { ApiResponse } from "@/types/common/ApiResponse";

export const authApi = {
  login: async (req: LoginRequest): Promise<LoginResponse> => {
    // axios.메서드<메서드 반환타입>();
    const res = await publicApi.post<ApiResponse<LoginResponse>>(
      // 경로부터 작성함
      API_ROUTES.AUTH.LOGIN,
      req
    );

    return res.data.data;
  },
};

// 로그인 요청 - 아래있는 코드를 위로 올린거임
// export async function login(req: LoginRequest): Promise<LoginResponse> {
//   const res = await publicApi.post<ApiResponse<LoginResponse>>(
//     API_ROUTES.AUTH.LOGIN,
//     req
//   );
//   return res.data.data;
// }
