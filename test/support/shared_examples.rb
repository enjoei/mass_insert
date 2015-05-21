def shared_examples
  describe 'Database Adapters' do
    let(:attributes) do
      {
        name: 'User Name',
        active: true,
        age: 25,
        money: 20.50,
        birth_date: Date.today,
        created_at: DateTime.now,
        updated_at: DateTime.now
      }
    end

    after :each do
      User.delete_all
    end

    describe 'Column types' do
      def setup
        User.mass_insert([attributes])
      end

      def user
        @user ||= User.last
      end

      it 'saves values correctly' do
        assert_equal user.name, 'User Name'
        assert_equal user.active, true
        assert_equal user.age, 25
        assert_equal user.money, 20.50
        assert_equal user.birth_date, Date.today
      end
    end

    describe 'Bulk inseting' do
      def array_of_values_with(size)
        (0...size).map do |i|
          attributes
        end
      end

      it 'saves 500 records correctly' do
        values = array_of_values_with(500)
        User.mass_insert(values)
        assert_equal User.count, 500
      end

      it 'saves 1000 records correctly' do
        values = array_of_values_with(1000)
        User.mass_insert(values)
        assert_equal User.count, 1000
      end

      it 'returns the ids' do
        values = array_of_values_with(10)
        ids = User.mass_insert(values, per_batch: 2)
        assert_equal User.count, 10
        assert_equal ids.size, 10
        assert_equal ids.first, [User.first.id.to_s]
      end

      it 'returns the fields in the option' do
        values = array_of_values_with(10)
        returning = User.mass_insert(values, per_batch: 2, returning: [:id, :name])
        assert_equal User.count, 10
        user = User.first
        assert_equal returning.first, [user.id.to_s, user.name]
      end
    end
  end
end
