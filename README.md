
**장점**
- header/footer 수정 시 전체 페이지 자동 반영
- main.jsp 교체만으로 다양한 페이지 제공 가능
- 페이지 구조와 디자인의 일관성 유지

---

### 2. 메인 페이지
![메인페이지](./images/main.png)

**담당 구현**
- index.jsp에서 header.jsp, main.jsp, footer.jsp 포함하는 기본 틀 제작
- 메인 화면(`home.jsp`)에 검색창, 이벤트 영역, 공지사항 영역 배치
- Bootstrap Grid 적용해 반응형 구성
- 그래픽 디자인 및 스타일링은 디자이너 협업

---

### 3. 후기/평점 시스템

#### DB 설계
![리뷰DB](./images/review_db.png)

**REVIEW**
| 컬럼명  | 타입         | 설명       |
|--------|-------------|-----------|
| num    | INT (PK)    | 리뷰 고유 번호 |
| user_id| VARCHAR(15) | 사용자 ID |
| hg_id  | VARCHAR(30) | 휴게소 ID |
| stars  | DOUBLE      | 평점 |
| content| VARCHAR(100)| 리뷰 내용 |
| good   | INT         | 추천 수 |
| writeday| DATE       | 작성일 |

**GOOD**
| 컬럼명  | 타입         | 설명       |
|--------|-------------|-----------|
| renum  | INT (PK)    | 참조 리뷰 번호 (REVIEW.num) |
| user_id| VARCHAR(45) | 추천한 사용자 ID |

📌 GOOD 테이블은 REVIEW.num을 외래키로 참조해 **추천 중복 방지** 구현

---

### 4. FAQ 페이지
![FAQ](./images/faq.png)

- main.jsp 영역에 아코디언 UI 구현
- 현재는 하드코딩 데이터 기반
- 비회원도 열람 가능
- 추후 DB 연동 및 관리 기능 확장 가능

---

## 📸 주요 화면

1. **메인 페이지**
   ![메인페이지](./images/main.png)

2. **FAQ 페이지**
   ![FAQ](./images/faq.png)

3. **후기 작성 페이지**
   ![후기작성](./images/review_form.png)

---

## 🚀 프로젝트 성과
- JSP 모듈화(index.jsp + header.jsp + main.jsp + footer.jsp)로 유지보수성 강화
- DB 외래키 설계로 추천 중복 방지 기능 구현
- 메인 페이지 기본 구조 완성 및 디자이너 협업으로 UI 완성도 향상
- 실제 서비스 수준의 기능 구현 및 시연 가능

---

## 📂 GitHub 링크
> 추후 GitHub 업로드 시 링크 삽입
