<!DOCTYPE html>
<html lang="sp">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <title>BarCamp2020</title>
        <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body id="page-top">

        <div class="page">
            <div class="page-main">
                <div class="my-3">
                    <div class="container">
                        <div class="d-flex">
                            <h2>Temperature vs Humidity</h2>
                        </div>
                        <div class="row row-cards">
                            <div class="col-lg-6">
                                <div class="card">
                                    <div id="temperatureChart" style="height: 300px; width: 100%;"></div>
                                    <div class="card-footer">
                                        <h4 class="m-0">Amount of readings: <span id="temp">-1</span></h4>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div id="humidityChart" style="height: 300px; width: 100%;"></div>
                                    <div class="card-footer">
                                        <h4 class="m-0">Amount of readings: <span id="hum">-1</span></h4>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js"></script>
        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.bundle.min.js"></script>
        <script src="http://canvasjs.com/assets/script/canvasjs.min.js"></script>
        <script>
            var webSocket;
            var dps = [];
            var temp = 0;
            var hum = 0;
            var dps2 = [];
            var chart = new CanvasJS.Chart("temperatureChart", {
                zoomEnabled: true,
                animationEnabled: true,
                theme: "dark2",
                title: {
                    text: "Temperature"
                },
                axisX:{
                    title: "Date",
                    interval: 10,
                    intervalType: "day",
                    crosshair: {
                        enabled: true,
                        snapToDataPoint: true
                    },

                },
                axisY: {
                    title: "Temperature",
                    lineThickness: 1,
                    crosshair: {
                        enabled: true,
                        snapToDataPoint: true,

                    },
                    titleFontColor: "#6D78AD",
                    lineColor: "#6D78AD",
                    gridThickness: 0,
                    lineThickness: 1,

                },
                data: [{
                    type: "line",
                    dataPoints: dps
                }]
            });
            var chart2 = new CanvasJS.Chart("humidityChart", {
                zoomEnabled: true,
                animationEnabled: true,
                theme: "dark2",
                title: {
                    text: "Humidity"
                },
                axisX:{
                    title: "Date",
                    interval: 10,
                    intervalType: "day",
                    crosshair: {
                        enabled: true,
                        snapToDataPoint: true
                    }
                },
                axisY: {
                    title: "Humidity",
                    crosshair: {
                        enabled: true,
                        snapToDataPoint: true,
                    },
                    titleFontColor: "#6D78AD",
                    lineColor: "#6D78AD",
                    gridThickness: 0,
                    lineThickness: 1,
                },
                data: [{
                    type: "line",
                    dataPoints: dps2
                }]
            });
            var updateInterval = 1000;
            var dataLength = 20;
            var updateChart = function (dataPoints) {
                var dp = JSON.parse(dataPoints);
                dps.push({
                    label: dp.date,
                    y: dp.temperature
                });
                dps2.push({
                    label: dp.date,
                    y: dp.humidity
                });
                temp = parseInt(document.getElementById("temp").innerText) + 1;
                document.getElementById("temp").innerText = temp.toString();
                hum = parseInt(document.getElementById("hum").innerText) + 1;
                document.getElementById("hum").innerText = temp.toString();
                chart.render();
                chart2.render();
            };
            function socketConnect() {
                webSocket = new WebSocket("ws://" + location.hostname + ":" + location.port + "/sensor_read");
                webSocket.onmessage = function (datos) {
                    console.log("I am making a connection");
                    updateChart(datos.data);
                };
            }
            function connect() {
                if (!webSocket || webSocket.readyState === 3) {
                    socketConnect();

                }
            }
            updateChart(dataLength);
            setInterval(connect, updateInterval);
        </script>
    </body>
</html>