package org.example.boardback.common.apis;

import static org.example.boardback.common.apis.ApiBase.BASE;

public class UserApi {
    private UserApi () {}
    // ============================================
    // 2. Users
    // ============================================
    public static final String ROOT = BASE + "/users";

    // ID_ONLY는 path variable로 특정 사용자 한명을 식별하는 경로 조각임 -> 단독으로 쓰이지 않고, 다른 경로와 조합됨
    public static final String ID_ONLY = "/{userId}";

    // 특정 사용자(타인) 한 명에 대한 CRUD 접근 용도
    public static final String BY_ID = ROOT + ID_ONLY;

    // 내 정보에 대한 접근 용도 -> 현재 로그인한 사용자 자신의 정보에 접근하는 용도 - userId를 path variable로 받지 않음
    public static final String ME = "/me";

    // 특정 유저의 비밀번호 변경 및 초기화 관련 엔드포인트
    // : {userId}/password
    // - 관리자가 사용자 비밀번호를 초기화 한다던지, 또는 비밀번호 완전 재설정
    public static final String PASSWORD = ID_ONLY + "/password";
}
