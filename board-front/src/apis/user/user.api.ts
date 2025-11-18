// user.api.ts

import type { ApiResponse } from "@/types/common/ApiResponse";
import { API_ROUTES } from "../common/apiMappingPattern";
import { privateApi, publicApi } from "../common/axiosInstance";
import type { UserDetail, UserList } from "@/types/user/user.type";

export const userApi = {
  getUser: async (userId: number): Promise<UserDetail> => {
    const res = await privateApi.get<ApiResponse<UserDetail>>(
      API_ROUTES.USERS.DETAIL(userId)
    );
    return res.data.data;
  },

  getUserList: async (): Promise<UserList> => {
    const res = await publicApi.get<ApiResponse<UserList>>(
      API_ROUTES.USERS.LIST
    );
    return res.data.data;
  },
};

// export async function fetchUserById(userId: number): Promise<UserDetail> {
//   const res = await publicApi.get<ApiResponse<UserDetail>>(
//     API_ROUTES.USERS.DETAIL(userId)
//   );

//   return res.data.data;
// }
