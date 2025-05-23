<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>주문 관리</title>
    <script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>

    <style>
        table {
          border-collapse: collapse;
          width: 100%;
        }

        th, td {
          padding: 8px;
          text-align: left;
          border-bottom: 1px solid #ddd;
        }

        .button-container button {
          margin-right: 8px;
        }
    </style>

</head>
<body>
<div id="app">
    <table>
        <thead>
        <tr>
            <th>주문번호</th>
            <th>주문내용</th>
            <th>상태</th>
            <th>액션</th>
        </tr>
        </thead>
        <tbody>
        <tr v-for="order in orders" :key="order.user_order_response.id">
            <td>{{ order.user_order_response.id }}</td>
            <td>
                <ul>
                    <li v-for="item in order.store_menu_response_list" :key="item.id">
                        {{ item.name }} {{ item.amount }}
                    </li>
                </ul>
            </td>
            <td>{{ order.user_order_response.status }}</td>
            <td class="button-container">
                <button @click="acceptOrder(order)">주문수락</button>
                <button @click="startCooking(order)">조리시작</button>
                <button @click="startDelivery(order)">배달시작</button>
            </td>
        </tr>
        </tbody>
    </table>
</div>

<script>
    new Vue({
      el: "#app",
      data: {
        orders: [] // 서버로부터 받은 주문 데이터를 저장할 배열
      },
      methods: {
        acceptOrder(order) {
          console.log("주문수락:", order);
        },
        startCooking(order) {
          console.log("조리시작:", order);
        },
        startDelivery(order) {
          console.log("배달시작:", order);
        },
        pushData(order){
            this.orders.unshift(order);
        }
      },
      mounted() {
        // SSE 연결
        const storeId=2;
        const url = `http://localhost:8081/api/sse/connect?storeId=${storeId}`;    // 접속주소
        const eventSource = new EventSource(url);               // sse 연결

        eventSource.onopen = event => {
            console.log("sse connection")
        }

        eventSource.onmessage = event => {
            console.log("receive : "+event.data);
            const data = JSON.parse(event.data);
            this.pushData(data);
        }
      }
    });
</script>
</body>
</html>