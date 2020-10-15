User.create(id: 1, username: 'testuser', email: 'sampleuser@example.com', password: 'password')
2.times do |i|
  Container.create(user_id: 1, name: "Container#{i}")
end
30.times do |i|
  Product.create(user_id: 1, container_id: 1, number: 2,  name: "product#{i}", product_created_at: '2020-04-04', product_expired_at: '2020-10-15')
end