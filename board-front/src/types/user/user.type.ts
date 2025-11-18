//! user.type.ts
//  : 입력 폼, 사용자 관련 일반 타입 정의



//? cf) DTO 와 FORM/Request 타입은 분리하는게 실무 표준임
// 프론트 입력 폼 작성용
export interface UserCreateForm {

}





























// 1) 도메인과 1:1 Mapping export
// : Table, Entity 기준
//    + Omit, Partial 방법 -> 필요없는건 이렇게 따로 빼놓기도 함

// 2) 도메인
//    + DTO 타입 정의 분리

// 따로 빼놓을거