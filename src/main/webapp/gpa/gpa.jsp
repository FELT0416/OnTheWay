<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="GpaData.GpaDto"%>
<%@page import="java.util.List"%>
<%@page import="GpaData.GpaDao"%>
<%@page import="java.net.URLEncoder"%> <%-- URL 인코딩을 위해 추가 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>고객 후기 페이지</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<style>
:root {
    --primary-color: #4A90E2; /* 부드러운 블루 */
    --primary-hover-color: #357ABD;
    --text-color-primary: #333;
    --text-color-secondary: #767676;
    --background-color: #f8f9fa;
    --card-background-color: #ffffff;
    --border-color: #e9ecef;
    --star-color: #FFD700; /* 골드 */
    --star-inactive-color: #FFD700;
    --success-color: #28a745;
    --danger-color: #dc3545;
    
    --font-family-main: 'Noto Sans KR', sans-serif;
    --border-radius-sm: 8px;
    --border-radius-md: 12px;
    --shadow-soft: 0 4px 12px rgba(0, 0, 0, 0.08);
    --shadow-medium: 0 8px 25px rgba(0, 0, 0, 0.1);
}

body {
    font-family: var(--font-family-main);
    background-color: var(--background-color);
    color: var(--text-color-primary);
    padding: 2rem 0;
    padding-top: 0px; /* 불필요한 중복 방지 */
}

.review-container {
    max-width: 900px;
    margin: 0 auto;
    padding: 0 1rem;
}

/* --- 상단 요약 섹션 --- */
.review-summary {
    background-color: var(--card-background-color);
    padding: 2rem;
    border-radius: var(--border-radius-md);
    box-shadow: var(--shadow-soft);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2.5rem;
    flex-wrap: wrap; /* 반응형을 위해 추가 */
    gap: 1rem; /* 요소 간 간격 추가 */
}

.summary-rating .rating-value {
    font-size: 2.5rem;
    font-weight: 700;
    color: var(--primary-color);
}

.summary-rating .rating-value i {
    font-size: 2rem;
    color: var(--star-color);
    margin-right: 0.5rem;
}

.summary-rating .total-reviews {
    font-size: 1rem;
    color: var(--text-color-secondary);
    font-weight: 500;
}

.sort-and-write {
    display: flex;
    align-items: center;
    gap: 1rem;
}

.sort-btn {
    font-family: var(--font-family-main);
    background-color: transparent;
    border: 1px solid var(--border-color);
    color: var(--text-color-secondary);
    border-radius: var(--border-radius-sm);
    padding: 0.6rem 1rem;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s, color 0.2s;
}
.sort-btn:hover {
    background-color: var(--background-color);
    color: var(--text-color-primary);
}

.review-write-btn {
    background-color: var(--primary-color);
    color: white;
    font-weight: 700;
    padding: 0.6rem 1.5rem;
    border-radius: var(--border-radius-sm);
    border: none;
    transition: background-color 0.2s;
}
.review-write-btn:hover {
    background-color: var(--primary-hover-color);
    color: white;
}

/* --- 🌟 리뷰 카드 (테이블 대체) --- */
.review-list {
    display: grid;
    gap: 1.5rem;
    /* 모바일에서는 1열, 태블릿 이상에서는 2열 (필요시) */
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); 
}

.review-card {
    background-color: var(--card-background-color);
    border: 1px solid var(--border-color);
    border-radius: var(--border-radius-md);
    padding: 1.5rem;
    box-shadow: var(--shadow-soft);
    position: relative;
    transition: transform 0.2s, box-shadow 0.2s;
}
.review-card:hover {
    transform: translateY(-5px);
    box-shadow: var(--shadow-medium);
}

.review-card-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 0.75rem;
}

.review-author .author-id {
    font-weight: 700;
    font-size: 1.1rem;
}
.review-author .write-date {
    font-size: 0.85rem;
    color: var(--text-color-secondary);
    margin-top: 2px;
}

.card-star-rating { color: var(--star-inactive-color); }
.card-star-rating .bi-star-fill { color: var(--star-color); }

.review-card-body p {
    line-height: 1.7;
    margin: 0;
}

.review-card-footer {
    margin-top: 1.5rem;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 0.75rem;
}

.thumb-btn {
    display: inline-flex;
    align-items: center;
    gap: 0.4rem;
    background-color: transparent;
    border: 1px solid var(--border-color);
    padding: 0.4rem 0.8rem;
    border-radius: 20px; /* pill shape */
    font-size: 0.9rem;
    color: var(--text-color-secondary);
    cursor: pointer;
    transition: all 0.2s;
    text-decoration: none; /* <a> 태그의 밑줄 제거 */
}
.thumb-btn:hover {
    color: var(--text-color-primary);
    background-color: #f1f1f1;
}
.thumb-btn .count { font-weight: 700; }
.thumb-btn.up:hover { border-color: var(--success-color); }
.thumb-btn.down:hover { border-color: var(--danger-color); }


.delete-btn {
    position: absolute;
    top: 1rem;
    right: 1rem;
    background: none;
    border: none;
    color: var(--text-color-secondary);
    cursor: pointer;
    opacity: 0; /* 기본적으로 숨김 */
    transition: opacity 0.2s;
    padding: 0.5rem;
    font-size: 1.1rem; /* 아이콘 크기 조정 */
}
.review-card:hover .delete-btn { opacity: 1; } /* 호버 시 보이도록 */
.delete-btn:hover { color: var(--danger-color); }


/* --- ✨ 후기 작성 모달 --- */
#reviewModal .modal-content {
    background-color: var(--card-background-color);
    border-radius: var(--border-radius-md);
    border: none;
    box-shadow: var(--shadow-medium);
    padding: 1.5rem;
    text-align: center;
}

#reviewModal .modal-header {
    border-bottom: none;
    text-align: center;
    justify-content: center;
    padding-top: 0;
}
#reviewModal .modal-title {
    font-size: 1.8rem;
    font-weight: 700;
    color: var(--text-color-primary);
}
#reviewModal .modal-title i {
    color: var(--primary-color);
}
#reviewModal .btn-close {
    position: absolute;
    top: 1.5rem;
    right: 1.5rem;
}

#reviewModal .modal-body { padding: 1rem 1.5rem; }

.rating-prompt {
    font-size: 1rem;
    color: var(--text-color-secondary);
    margin-bottom: 1rem;
    font-weight: 500;
}

/* 인터랙티브 별점 시스템 */
.interactive-star-rating {
    display: flex;
    justify-content: center;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.interactive-star-rating .bi {
    font-size: 2.5rem;
    color: var(--star-inactive-color);
    cursor: pointer;
    transform-origin: center;
    transition: color 0.2s ease, transform 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
}
/* 호버 시 별점 모두 활성화 */
.interactive-star-rating:hover .bi { color: var(--star-color); }
/* 선택된 별점 이후의 별점은 비활성화 */
.interactive-star-rating .bi:hover ~ .bi { color: var(--star-inactive-color); }
/* 선택된 별점 */
.interactive-star-rating .bi.selected { color: var(--star-color); }
/* 선택된 별점 이후의 별점은 비활성화 (선택된 상태에서도) */
.interactive-star-rating .bi.selected ~ .bi { color: var(--star-inactive-color); }
.interactive-star-rating .bi:hover { transform: scale(1.2); }


.rating-feedback {
    min-height: 24px;
    font-weight: 700;
    color: var(--primary-color);
    transition: opacity 0.3s;
    margin-bottom: 1.5rem;
}

#reviewModal textarea.form-control {
    min-height: 150px;
    border-radius: var(--border-radius-md);
    border: 1px solid var(--border-color);
    resize: none;
    padding: 1rem;
}
#reviewModal textarea.form-control:focus {
    border-color: var(--primary-color);
    box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.2);
}

#reviewModal .modal-footer {
    border-top: none;
    display: flex;
    justify-content: center;
    gap: 1rem;
    padding-bottom: 0;
}
#reviewModal .modal-footer .btn {
    min-width: 120px;
    padding: 0.75rem 1.5rem;
    font-weight: 700;
    border-radius: var(--border-radius-sm);
    border: none;
}
#reviewModal .btn-submit {
    background-color: var(--primary-color);
    color: white;
}
#reviewModal .btn-submit:hover { background-color: var(--primary-hover-color); }
#reviewModal .btn-cancel {
    background-color: var(--border-color);
    color: var(--text-color-secondary);
}
#reviewModal .btn-cancel:hover { background-color: #dcdfe2; }


/* --- 토스트 알림 --- */
#toast {
   visibility: hidden;
   min-width: 250px;
   background-color: #333;
   color: #fff;
   text-align: center;
   border-radius: var(--border-radius-sm);
   padding: 1rem;
   position: fixed;
   z-index: 9999;
   top: 20px;
   left: 50%;
   transform: translateX(-50%);
   font-size: 1rem;
   font-weight: 500;
   box-shadow: var(--shadow-medium);
   opacity: 0;
   transition: opacity 0.5s, top 0.5s; /* 부드러운 애니메이션 */
}

#toast.show {
   visibility: visible;
   opacity: 1;
   top: 40px; /* 약간 아래로 내려오면서 나타나도록 */
}
#toast.error { background-color: var(--danger-color); }

/* 모바일 반응형 (선택 사항) */
@media (max-width: 576px) {
    .review-summary {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
    .sort-and-write {
        width: 100%;
        justify-content: center;
    }
    .sort-btn, .review-write-btn {
        flex-grow: 1;
    }
}
</style>
</head>

<body>

<%
// --- Java 로직 (기존 유지) ---
String already = request.getParameter("already");
String success = request.getParameter("success");
String duplicate = request.getParameter("duplicate");

String pageParam = request.getParameter("page");
String order = request.getParameter("order");
if (order == null || order.isEmpty()) order = "추천순";

int currentPage = (pageParam == null || pageParam.isEmpty()) ? 1 : Integer.parseInt(pageParam);
int perPage = 10; // 페이지당 카드 개수
int start = (currentPage - 1) * perPage;

String hg_id = request.getParameter("hg_id");
GpaDao dao = new GpaDao();
double avgStars = dao.getAverageStarsByHgId(hg_id);
int totalCount = dao.getCountByHgId(hg_id);
String hgName = dao.getHgName(hg_id);
List<GpaDto> list = dao.getReviewsByHgIdPaging(hg_id, start, perPage, order);
SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd");

String userid = (String) session.getAttribute("userId");

%>

<%-- 토스트 메시지 출력 (JS 로직보다 상단에 위치) --%>
<div id="toast"></div>

<% if ("1".equals(already)) { %>
<script>
document.addEventListener("DOMContentLoaded", function () { showToast("추천/비추천은 한 번만 가능합니다.", "error"); });
</script>
<% } %>

<% if ("1".equals(success)) { %>
<script>
document.addEventListener("DOMContentLoaded", function () { showToast("후기 등록이 완료되었습니다."); });
</script>
<% } %>

<% if ("1".equals(duplicate)) { %>
<script>
document.addEventListener("DOMContentLoaded", function () { showToast("이미 평점을 등록하셨습니다.", "error"); });
</script>
<% } %>


<div class="review-container">
    <header class="review-summary">
        <div class="summary-rating">
            <span class="rating-value"><i class="bi bi-star-fill"></i><%=String.format("%.1f", avgStars)%></span>
           <div class="total-reviews">
    <a href="<%=request.getContextPath()%>/index.jsp?main=details/info.jsp&hg_id=<%=hg_id%>" class="text-decoration-none fw-bold text-primary">
        <%=hgName%>
    </a>
    휴게소에 대한 <%=totalCount%>개의 소중한 후기
</div>

      
        <div class="sort-and-write">
            <button class="sort-btn" onclick="toggleOrder()">
                <i class="bi bi-arrow-down-up"></i>
                <span id="orderText"><%=order%></span>
            </button>
            <button class="btn review-write-btn"
                <%if (userid == null) {%>
                onclick="alert('로그인 후 후기를 작성할 수 있습니다.');"
                <%} else {%>
                data-bs-toggle="modal" data-bs-target="#reviewModal"
                <%}%>>
                <i class="bi bi-pencil-square"></i> 후기 작성
            </button>
        </div>
    </header>

    <main class="review-list">
        <% if (list.isEmpty()) { %>
            <div class="col-12 text-center text-muted py-5">
                <p class="fs-5"><i class="bi bi-exclamation-circle me-2"></i>아직 등록된 후기가 없습니다.</p>
                <p>첫 후기를 작성하고 <%= hgName %>휴게소에 대한 경험을 공유해 보세요!</p>
            </div>
        <% } else { %>
            <% for (GpaDto dto : list) { %>
            <article class="review-card">
                <div class="review-card-header">
                    <div class="review-author">
                        <div class="author-id"><%=dto.getUserid()%></div>
                        <div class="write-date"><%=sdf.format(dto.getWriteday())%></div>
                    </div>
                    <div class="card-star-rating">
                        <% for(int i=1; i<=5; i++){ %>
                            <i class="bi <%= (dto.getStars() >= i) ? "bi-star-fill" : "bi-star" %>"></i>
                        <% } %>
                    </div>
                </div>
                <div class="review-card-body">
                    <p><%=dto.getContent()%></p>
                </div>
                <div class="review-card-footer">
	                <%
					    Object roleObj = session.getAttribute("role");
					    int role = (roleObj != null) ? Integer.parseInt(roleObj.toString()) : 0;
					%>
				                
                    <% if ((userid != null && userid.equals(dto.getUserid())) || role == 1) { %>
                        <button class="delete-btn" onclick="confirmDelete('<%=dto.getNum()%>', '<%=URLEncoder.encode(hg_id, "UTF-8")%>', '<%=URLEncoder.encode(order, "UTF-8")%>')">
                            <i class="bi bi-trash3"></i>
                        </button>
                    <% } %>
                    <a href="<%= (userid == null) ? "javascript:alert('로그인 후 이용 가능합니다.');" : request.getContextPath()+"/gpa/goodUpdate.jsp?num="+dto.getNum()+"&type=up&hg_id="+URLEncoder.encode(hg_id, "UTF-8")+"&order="+URLEncoder.encode(order, "UTF-8") %>" class="thumb-btn up">
                        <i class="bi bi-hand-thumbs-up"></i>
                        <span class="count"><%=dto.getGood()%></span>
                    </a>
                    <a href="<%= (userid == null) ? "javascript:alert('로그인 후 이용 가능합니다.');" : request.getContextPath()+"/gpa/goodUpdate.jsp?num="+dto.getNum()+"&type=down&hg_id="+URLEncoder.encode(hg_id, "UTF-8")+"&order="+URLEncoder.encode(order, "UTF-8") %>" class="thumb-btn down">
                        <i class="bi bi-hand-thumbs-down"></i>
                    </a>
                </div>
            </article>
            <% } %>
        <% } %>
    </main>

    <div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="<%=request.getContextPath()%>/gpa/gpaAction.jsp" method="post">
                    <input type="hidden" name="userid" value="<%=userid%>">
                    <input type="hidden" name="hg_id" value="<%=hg_id%>">
                    <input type="hidden" name="order" value="<%=order%>">
                    <input type="hidden" name="stars" id="modalRatingValue" value="0">

                    <div class="modal-header">
                        <h5 class="modal-title" id="reviewModalLabel"><i class="bi bi-chat-quote-fill"></i> 소중한 후기를 들려주세요</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <p class="rating-prompt">이 장소에 대한 경험은 어떠셨나요?</p>
                        <div class="interactive-star-rating" id="modalStarRating">
                            <i class="bi bi-star" data-value="1"></i>
                            <i class="bi bi-star" data-value="2"></i>
                            <i class="bi bi-star" data-value="3"></i>
                            <i class="bi bi-star" data-value="4"></i>
                            <i class="bi bi-star" data-value="5"></i>
                        </div>
                        <p class="rating-feedback" id="ratingFeedbackText">&nbsp;</p>

                        <textarea name="content" class="form-control" placeholder="자세한 후기를 작성해주시면 다른 사용자에게 큰 도움이 됩니다." required></textarea>
                    </div>

                    <div class="modal-footer">
                    	<button type="submit" class="btn btn-submit">등록하기</button>
                        <button type="button" class="btn btn-cancel" data-bs-dismiss="modal">취소</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%
    int totalPage = (int) Math.ceil(totalCount / (double) perPage);
    if(totalPage > 1) {
    %>
    <nav aria-label="Page navigation" class="mt-5">
      <ul class="pagination justify-content-center">
         <% for (int i = 1; i <= totalPage; i++) { %>
         <li class="page-item <%=(i == currentPage) ? "active" : ""%>">
            <a class="page-link" href="<%=request.getContextPath()%>/index.jsp?main=gpa/gpa.jsp&hg_id=<%=URLEncoder.encode(hg_id, "UTF-8")%>&page=<%=i%>&order=<%=URLEncoder.encode(order, "UTF-8")%>"><%=i%></a>
         </li>
         <% } %>
      </ul>
   </nav>
   <% } %>

</div> <%-- /.review-container --%>

<script>
// --- 스크립트 ---

// 모달 인터랙티브 별점 시스템
document.addEventListener("DOMContentLoaded", function () {
    const stars = document.querySelectorAll("#modalStarRating .bi");
    const ratingInput = document.getElementById("modalRatingValue");
    const feedbackText = document.getElementById("ratingFeedbackText");
    const ratingFeedbacks = {
        0: "&nbsp;",
        1: "별로예요",
        2: "조금 아쉬워요",
        3: "괜찮아요",
        4: "좋아요",
        5: "아주 좋아요!"
    };

    stars.forEach(star => {
        star.addEventListener("mouseover", handleMouseOver);
        star.addEventListener("click", handleClick);
    });

    document.getElementById('modalStarRating').addEventListener('mouseleave', handleMouseLeave);

    function handleMouseOver(e) {
        // 호버 시 별 채우기: 마우스가 별점 영역에 들어오면 해당 별과 그 앞의 별들을 채웁니다.
        const hoverValue = e.target.dataset.value;
        stars.forEach(star => {
            star.classList.toggle("bi-star-fill", star.dataset.value <= hoverValue);
            star.classList.toggle("bi-star", star.dataset.value > hoverValue);
        });
    }

    function handleClick(e) {
        const selectedValue = e.target.dataset.value;
        ratingInput.value = selectedValue;
        feedbackText.textContent = ratingFeedbacks[selectedValue];
        
        // 클릭 시 모든 별점의 'selected' 클래스를 제거하고
        // 선택된 값까지 'selected'와 'bi-star-fill' 클래스를 추가합니다.
        stars.forEach(star => {
            star.classList.remove("selected", "bi-star-fill", "bi-star"); // 모든 클래스 초기화
            if (star.dataset.value <= selectedValue) {
                star.classList.add("selected", "bi-star-fill"); // 선택된 별은 채우고 selected 표시
            } else {
                star.classList.add("bi-star"); // 선택되지 않은 별은 비웁니다.
            }
        });
    }

    function handleMouseLeave() {
        const selectedValue = ratingInput.value;
        // 선택된 별점이 있을 경우: 마우스가 별점 영역을 벗어나도 선택된 별점은 유지합니다.
        if (selectedValue > 0) {
            stars.forEach(star => {
                star.classList.remove("bi-star-fill", "bi-star"); // 현재 상태 초기화
                if (star.dataset.value <= selectedValue) {
                    star.classList.add("bi-star-fill"); // 선택된 별점까지는 항상 채워진 상태 유지
                } else {
                    star.classList.add("bi-star"); // 그 이후는 비어있는 상태 유지
                }
            });
        } else { // 선택된 별점이 없을 경우 (초기 상태): 모든 별을 비어있는 상태로 유지합니다.
            stars.forEach(star => {
                star.classList.remove("bi-star-fill", "bi-star");
                star.classList.add("bi-star"); 
            });
        }
    }
    
    // 모달이 닫힐 때 별점 초기화
    const reviewModal = document.getElementById('reviewModal');
    reviewModal.addEventListener('hidden.bs.modal', function () {
        ratingInput.value = 0;
        feedbackText.innerHTML = ratingFeedbacks[0]; // 피드백 텍스트 초기화
        stars.forEach(star => {
            star.className = 'bi bi-star'; // 모든 별을 비어있는 상태로 초기화
            star.classList.remove("selected"); // selected 클래스도 제거
        });
    });
});


// 토스트 알림
function showToast(message, type = "success") {
   const toast = document.getElementById("toast");
   toast.textContent = message;
   toast.className = "show";
   if (type === 'error') {
       toast.classList.add('error');
   }
   setTimeout(() => { toast.className = toast.className.replace("show", ""); }, 3000);
}

// 정렬 순서 변경
function toggleOrder() {
   let orderModes = ["최신순", "추천순", "평점 높은순", "평점 낮은순"];
   let currentOrderIndex = orderModes.indexOf("<%=order%>");
   currentOrderIndex = (currentOrderIndex + 1) % orderModes.length;
   const selectedOrder = orderModes[currentOrderIndex];
   // hg_id와 order, page를 모두 넘겨야 합니다.
   location.href = "<%=request.getContextPath()%>/index.jsp?main=gpa/gpa.jsp&hg_id=<%=URLEncoder.encode(hg_id, "UTF-8")%>&order=" + encodeURIComponent(selectedOrder) + "&page=1";
}

// 삭제 확인
function confirmDelete(num, hg_id, order) {
    if (confirm("이 후기를 정말 삭제하시겠습니까?")) {
        location.href = "<%=request.getContextPath()%>/gpa/deleteGpa.jsp?num=" + num + "&hg_id=" + hg_id + "&order=" + order;
    }
}
</script>
</body>
</html>