// user.type.ts

// 1) 도메인과 1:1 Mapping export
// : Table, Entity 기준
//    + Omit, Partial 방법 -> 필요없는건 이렇게 따로 빼놓기도 함

// 2) 도메인
//    + DTO 타입 정의 분리
export interface User {

}

// 따로 빼놓을거
export interface UserDetail {

}

export interface UserListData {

}

export type UserList = UserListData[];
