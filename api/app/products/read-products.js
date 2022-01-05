jQuery(function($){

    // показать список товаров при первой загрузке
    showProducts();
    // при нажатии кнопки
    $(document).on('click', '.read-products-button', function(){
        showProducts();
    });

// функция для показа списка товаров
    function showProducts(){

    }

// получить список товаров из API
    $.getJSON("http://localhost:8080/product/read.php", function(data){



// html for listing products
        var read_products_html=`
    <!-- при нажатии загружается форма создания продукта -->
    <div id='create-product' class='btn btn-primary pull-right m-b-15px create-product-button'>
        <span class='glyphicon glyphicon-plus'></span> Создание товара
    </div>
    <!-- начало таблицы -->
<table class='table table-bordered table-hover'>

    <!-- создание заголовков таблицы -->
    <tr>
        <th class='w-15-pct'>Название</th>
        <th class='w-10-pct'>Цена</th>
        <th class='w-15-pct'>Категория</th>
        <th class='w-25-pct text-align-center'>Действие</th>
    </tr>`;

// перебор списка возвращаемых данных
        $.each(data.records, function(key, val) {

            // создание новой строки таблицы для каждой записи
            read_products_html+=`
        <tr>

            <td>` + val.name + `</td>
            <td>` + val.price + `</td>
            <td>` + val.category_name + `</td>

            <!-- кнопки 'действий' -->
            <td>
                <!-- кнопка чтения товара -->
                <button class='btn btn-primary m-r-10px read-one-product-button' data-id='` + val.id + `'>
                    <span class='glyphicon glyphicon-eye-open'></span> Просмотр
                </button>

                <!-- кнопка редактирования -->
                <button class='btn btn-info m-r-10px update-product-button' data-id='` + val.id + `'>
                    <span class='glyphicon glyphicon-edit'></span> Редактирование
                </button>

                <!-- кнопка удаления товара -->
                <button class='btn btn-danger delete-product-button' data-id='` + val.id + `'>
                    <span class='glyphicon glyphicon-remove'></span> Удаление
                </button>
            </td>

        </tr>`;
        });

// конец таблицы
        read_products_html+=`</table>`;
// вставка в 'page-content' нашего приложения
        $("#page-content").html(read_products_html);
// изменяем заголовок страницы
        changePageTitle("Все товары");

    });
});
