require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 3
  end

  test 'render a detailde products page' do
    get product_path(products(:ps4))

    assert_response :success
    assert_select '.title', 'PS4'
    assert_select '.description', 'estado de novo'
    assert_select '.price', '100'
  end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allow to create a new product' do
    post products_path, params: {
      product: {
        title: 'PS4',
        description: 'estado de novo',
        price: 100,
        category_id:  categories(:videogames).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Produto cadastrado com sucesso'
  end

  test 'does not allow to create a new product with empty field' do
    post products_path, params: {
      product: {
        title: '',
        description: 'estado de novo',
        price: 100
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render an edit product form' do
    get edit_product_path(products(:ps4))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a product' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: 150
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Alteração do produto feita com sucesso'
  end

  test 'dois not allow to update a product with an invalid field' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: nil
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count', -1) do
     delete product_path(products(:ps4))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Produto deletado com sucesso'
  end
end