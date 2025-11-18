package org.example.boardback.common.constants;

/**
 * 1) 공통 Prefix: /api/v1
 * 2) 도메인 단위로 그룹핑
 *  - api/v1/auth | api/v1/users | api/v1/menus | ...
 *
 * Api MappingPattern
 * ---------------------------------
 * - 실무 RESTful API URL 패턴을 한 곳에서 관리하는 상수 클래스
 * - 도메인 단위 그룹을 구성할거임
 * - 확장성 / 유지보수성 / 일관성 강화
 *
 * [권장 규칙]
 * 1) BASE = /api/v1
 * 2) ROOT = BASE + "/resource"
 * 3) ID_ONLY = "/{id}"
 * 4) 중첩 리소스 = ROOT + ID_ONLY + "sub-resource"
 *
 */

public class ApiMappingPattern {
    private ApiMappingPattern() {}





    public static final class Auth {
        private Auth(){}


    }


    public static final class Users {
        private Users () {}


    }

    public static final class Board {
        private Board () {}




    }


}
