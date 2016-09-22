require "test_helper"

describe JustBackgammon::GameState do
  let(:game_in_move_phase) {
    JustBackgammon::GameState.new({
      current_player_number: 1,
      current_phase: 'move',
      dice: [
        { number: 1 },
        { number: 2 }
      ],
      bar: { pieces: [] },
      points: [
        { number: 1, pieces: [{owner: 1}, {owner: 1}] },
        { number: 2, pieces: [] },
        { number: 3, pieces: [] },
        { number: 4, pieces: [] },
        { number: 5, pieces: [] },
        { number: 6, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },
        { number: 7, pieces: [] }
      ],
      off_board: { pieces: [{owner: 2}] }
    })
  }

  let(:game_with_no_moves) {
    JustBackgammon::GameState.new({
      current_player_number: 1,
      current_phase: 'move',
      dice: [
        { number: 1 },
        { number: 2 }
      ],
      bar: { pieces: [] },
      points: [
        { number: 1, pieces: [{owner: 1}, {owner: 1}] },
        { number: 2, pieces: [{owner: 2}, {owner: 2}] },
        { number: 3, pieces: [{owner: 2}, {owner: 2}] }
      ],
      off_board: { pieces: [] }
    })
  }

  let(:game_in_roll_phase) {
    JustBackgammon::GameState.new({
      current_player_number: 1,
      current_phase: 'roll',
      dice: [
        { number: nil },
        { number: nil }
      ],
      bar: { pieces: [] },
      points: [
        { number: 1, pieces: [{owner: 1}, {owner: 1}] },
        { number: 2, pieces: [] },
        { number: 3, pieces: [] }
      ],
      off_board: { pieces: [] }
    })
  }

  let(:winning_game) {
    JustBackgammon::GameState.new({
      current_player_number: 1,
      current_phase: 'roll',
      dice: [
        { number: nil },
        { number: nil }
      ],
      bar: { pieces: [] },
      points: [
        { number: 1, pieces: [{owner: 2}, {owner: 2}] },
        { number: 2, pieces: [] },
        { number: 3, pieces: [] }
      ],
      off_board: {
        pieces: [
          {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1},
          {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1},
          {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}, {owner: 1}
        ]
      }
    })
  }


  describe 'initializing a game' do
    let(:arguments) {
      {
        current_player_number: 2,
        current_phase: 'move',
        dice: [
          { number: 1 },
          { number: 3 }
        ],
        bar: { pieces: [{owner: 1}] },
        points: [
          { number: 1, pieces: [{owner: 2}] }
        ],
        off_board: { pieces: [{owner: 2}] }
      }
    }
    let(:game_state) { JustBackgammon::GameState.new(arguments) }

    it 'must set the board with the arguments passed' do
      assert_equal 2, game_state.current_player_number
      assert_equal 'move', game_state.current_phase
      assert_equal 1, game_state.dice.find_by_number(1).number
      assert_equal 3, game_state.dice.find_by_number(3).number
      assert_equal 1, game_state.bar.pieces.first.owner
      assert_equal 1, game_state.points.find_by_number(1).number
      assert_equal 2, game_state.points.find_by_number(1).pieces.first.owner
      assert_equal 2, game_state.off_board.pieces.first.owner
    end
  end

  describe 'the default game' do
    let(:game_state) { JustBackgammon::GameState.default }

    it 'must set the board in the starting position' do
      assert_equal 1, game_state.current_player_number
      assert_equal 'roll', game_state.current_phase

      assert game_state.dice.numbers.all?(&:nil?)

      assert_equal 0, game_state.bar.pieces.size

      assert_equal 1, game_state.points.find_by_number(1).number
      assert_equal 2, game_state.points.find_by_number(1).pieces.size
      assert_equal 1, game_state.points.find_by_number(1).pieces.first.owner

      assert_equal 6, game_state.points.find_by_number(6).number
      assert_equal 5, game_state.points.find_by_number(6).pieces.size
      assert_equal 2, game_state.points.find_by_number(6).pieces.first.owner

      assert_equal 8, game_state.points.find_by_number(8).number
      assert_equal 3, game_state.points.find_by_number(8).pieces.size
      assert_equal 2, game_state.points.find_by_number(8).pieces.first.owner

      assert_equal 12, game_state.points.find_by_number(12).number
      assert_equal 5,  game_state.points.find_by_number(12).pieces.size
      assert_equal 1,  game_state.points.find_by_number(12).pieces.first.owner

      assert_equal 13, game_state.points.find_by_number(13).number
      assert_equal 5,  game_state.points.find_by_number(13).pieces.size
      assert_equal 2,  game_state.points.find_by_number(13).pieces.first.owner

      assert_equal 17, game_state.points.find_by_number(17).number
      assert_equal 3,  game_state.points.find_by_number(17).pieces.size
      assert_equal 1,  game_state.points.find_by_number(17).pieces.first.owner

      assert_equal 19, game_state.points.find_by_number(19).number
      assert_equal 5,  game_state.points.find_by_number(19).pieces.size
      assert_equal 1,  game_state.points.find_by_number(19).pieces.first.owner

      assert_equal 24, game_state.points.find_by_number(24).number
      assert_equal 2,  game_state.points.find_by_number(24).pieces.size
      assert_equal 2,  game_state.points.find_by_number(24).pieces.first.owner

      assert_equal 0, game_state.off_board.pieces.size
    end
  end

  describe 'roll' do
    let(:player) { 1 }
    let(:other_player) { 2 }

    describe "on the player's turn" do
      describe 'during the roll phase' do
        it 'must roll the dice' do
          game_in_roll_phase.roll(player)
          assert game_in_roll_phase.dice.numbers.none?(&:nil?)
        end

        it 'must change the phase' do
          game_in_roll_phase.roll(player)
          assert_equal 'move', game_in_roll_phase.current_phase
        end
      end

      describe 'during the move phase' do
        it 'must not roll the dice' do
          game_in_move_phase.roll(player)
          assert_equal 1, game_in_move_phase.dice.find_by_number(1).number
          assert_equal 2, game_in_move_phase.dice.find_by_number(2).number
        end

        it 'must not change phase' do
          game_in_move_phase.roll(player)
          assert_equal 'move', game_in_move_phase.current_phase
        end

        it 'must add WrongPhaseError' do
          game_in_move_phase.roll(player)
          error = game_in_move_phase.errors.find { |e| e.instance_of?(JustBackgammon::WrongPhaseError) }
          refute_nil error
        end
      end
    end

    describe "not on the player's turn" do
      let(:game) { JustBackgammon::GameState.default }

      it 'must not roll the dice' do
        game.roll(other_player)
        assert game.dice.numbers.all?(&:nil?)
      end

      it 'must not change the phase' do
        game.roll(other_player)
        assert_equal 'roll', game.current_phase
      end

      it 'must add NotPlayersTurnError' do
        game.roll(other_player)
        error = game.errors.find { |e| e.instance_of?(JustBackgammon::NotPlayersTurnError) }
        refute_nil error
      end
    end
  end

  describe 'move' do
    let(:player) { 1 }
    let(:other_player) { 2 }

    describe "on the player's turn" do
      describe 'during the move phase' do
        describe 'with a valid move' do
          let(:valid_move) { [{from: 1, to: 2}, {from: 1, to: 3}] }

          it 'must move pieces' do
            game_in_move_phase.move(player, valid_move)
            assert_equal 0, game_in_move_phase.points.find_by_number(1).pieces.size
            assert_equal 1, game_in_move_phase.points.find_by_number(2).pieces.size
            assert_equal 1, game_in_move_phase.points.find_by_number(3).pieces.size
          end

          it 'must change phase' do
            game_in_move_phase.move(player, valid_move)
            assert_equal 'roll', game_in_move_phase.current_phase
          end

          it 'must change player number' do
            game_in_move_phase.move(player, valid_move)
            assert_equal other_player, game_in_move_phase.current_player_number
          end

          it 'must reset the dice' do
            game_in_move_phase.move(player, valid_move)
            assert game_in_move_phase.dice.numbers.all?(&:nil?)
          end

          it 'must not have any errors' do
            game_in_move_phase.move(player, valid_move)
            assert_equal [], game_in_move_phase.errors
          end

          it 'must return true' do
            assert game_in_move_phase.move(player, valid_move)
          end
        end

        describe 'with an invalid move' do
          let(:invalid_move) { [{from: 1, to: 2}, {from: 1, to: 6}] }

          it 'must not move any pieces' do
            game_in_move_phase.move(player, invalid_move)
            assert_equal 2, game_in_move_phase.points.find_by_number(1).pieces.size
          end

          it 'must not change phase' do
            game_in_move_phase.move(player, invalid_move)
            assert_equal 'move', game_in_move_phase.current_phase
          end

          it 'must return false' do
            refute game_in_move_phase.move(player, invalid_move)
          end
        end
      end

      describe 'during the roll phase' do
        let(:move) { [{from: 1, to: 2}, {from: 1, to: 3}] }

        it 'must not move any pieces' do
          game_in_roll_phase.move(player, move)
          assert_equal 2, game_in_roll_phase.points.find_by_number(1).pieces.size
        end

        it 'must not change phase' do
          game_in_roll_phase.move(player, move)
          assert_equal 'roll', game_in_roll_phase.current_phase
        end

        it 'must add WrongPhaseError' do
          game_in_roll_phase.move(player, move)
          error = game_in_roll_phase.errors.find { |e| e.instance_of?(JustBackgammon::WrongPhaseError) }
          refute_nil error
        end

        it 'must return false' do
          refute game_in_roll_phase.move(player, move)
        end
      end
    end

    describe "not on the player's turn" do
      let(:move) { [{from: 1, to: 2}, {from: 1, to: 3}] }

      it 'must not move any pieces' do
        game_in_move_phase.move(other_player, move)
        assert_equal 2, game_in_move_phase.points.find_by_number(1).pieces.size
      end

      it 'must not change the phase' do
        game_in_move_phase.move(other_player, move)
        assert_equal 'move', game_in_move_phase.current_phase
      end

      it 'must add NotPlayersTurnError' do
        game_in_move_phase.move(other_player, move)
        error = game_in_move_phase.errors.find { |e| e.instance_of?(JustBackgammon::NotPlayersTurnError) }
        refute_nil error
      end

      it 'must return false' do
        refute game_in_move_phase.move(other_player, move)
      end
    end

    describe 'with from that does not exist' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: -50, to: 1}, {from: 1, to: 2} ] }

      it 'must add a PointNotFoundError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::PointNotFoundError) }
      end
    end

    describe 'with to that does not exist' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 50}, {from: 1, to: 2} ] }

      it 'must add a PointNotFoundError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::PointNotFoundError) }
      end
    end

    describe 'with an empty from' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 3, to: 5} ] }

      it 'must add a EmptyPoint to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::EmptyPointError) }
      end
    end

    describe 'with a from not owned by the player' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] },
            { number: 6, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },
            { number: 7, pieces: [] }
          ],
          off_board: { pieces: [{owner: 2}] }
        })
      }
      let(:list) { [ {from: 6, to: 7}, {from: 1, to: 2} ] }

      it 'must add a PointOwnershipError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::PointOwnershipError) }
      end
    end

    describe 'with a move blocked by the opponent' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 5 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] },
            { number: 6, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },
            { number: 7, pieces: [] }
          ],
          off_board: { pieces: [{owner: 2}] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 1, to: 6} ] }

      it 'must add a BlockedError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::BlockedError) }
      end
    end

    describe 'with a move in the wrong direction' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 5 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] },
            { number: 6, pieces: [{owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}, {owner: 2}] },
            { number: 7, pieces: [] },
            { number: 8, pieces: [{owner: 1}, {owner: 1}, {owner: 1}] }
          ],
          off_board: { pieces: [{owner: 2}] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 8, to: 7} ] }

      it 'must add a WrongDirectionError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::WrongDirectionError) }
      end
    end

    describe 'with the number of pieces on the bar exceeding the moves from the bar' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 5 }
          ],
          bar: { pieces: [{owner: 1}] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 1, to: 3} ] }

      it 'must add a PiecesOnBarError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::PiecesOnBarError) }
      end
    end

    describe 'with move lengths not matching dice' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 1, to: 5} ] }

      it 'must add a DiceMismatchError to errors' do
        game.move(player, list)
        refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::DiceMismatchError) }
      end
    end

    describe 'with move that moves the same piece twice' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 2, to: 4} ] }

      it 'must add not have errors' do
        game.move(player, list)
        assert_empty game.errors
      end
    end

    describe 'with move that moves the same piece twice and hits a blot' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [{owner: 2}] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 2, to: 4} ] }

      it 'must add not have errors' do
        game.move(player, list)
        assert_empty game.errors
      end
    end

    describe 'with move on to a blot' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [] },
          points: [
            { number: 1, pieces: [{owner: 1}, {owner: 1}] },
            { number: 2, pieces: [{owner: 2}] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [ {from: 1, to: 2}, {from: 1, to: 3} ] }

      it 'must move the blot on to the bar' do
        game.move(player, list)
        assert_equal 1, game.bar.pieces.size
      end
    end

    describe 'an empty move when no moves are possible' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [{owner: 1}, {owner: 1}] },
          points: [
            { number: 1, pieces: [{owner: 2}, {owner: 2}] },
            { number: 2, pieces: [{owner: 2}, {owner: 2}] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [] }

      it 'must not have error' do
        game.move(player, list)
        assert_empty game.errors
      end
    end

    describe 'a partial move when some moves are possible' do
      let(:game) {
        JustBackgammon::GameState.new({
          current_player_number: 1,
          current_phase: 'move',
          dice: [
            { number: 1 },
            { number: 2 }
          ],
          bar: { pieces: [{owner: 1}, {owner: 1}] },
          points: [
            { number: 1, pieces: [{owner: 2}, {owner: 2}] },
            { number: 2, pieces: [] },
            { number: 3, pieces: [] },
            { number: 4, pieces: [] },
            { number: 5, pieces: [] }
          ],
          off_board: { pieces: [] }
        })
      }
      let(:list) { [{from: 'bar', to: 2}] }

      it 'must not have errors' do
        game.move(player, list)
        assert_empty game.errors
      end
    end

    describe 'from a bar' do
      describe 'with a valid move' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [{owner: 1}] },
            points: [
              { number: 1, pieces: [{owner: 1}] },
              { number: 2, pieces: [] },
              { number: 3, pieces: [] },
              { number: 4, pieces: [] },
              { number: 5, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 'bar', to: 1}, {from: 1, to: 3} ] }

        it 'must not have error' do
          game.move(player, list)
          assert_empty game.errors
        end
      end

      describe 'with move lengths not matching dice' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [{owner: 1}] },
            points: [
              { number: 1, pieces: [{owner: 1}] },
              { number: 2, pieces: [] },
              { number: 3, pieces: [] },
              { number: 4, pieces: [] },
              { number: 5, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 'bar', to: 4}, {from: 1, to: 2} ] }

        it 'must have a dice mismatch error' do
          game.move(player, list)
          refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::DiceMismatchError) }
        end
      end

      describe 'from an empty bar' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 1, pieces: [{owner: 1}] },
              { number: 2, pieces: [] },
              { number: 3, pieces: [] },
              { number: 4, pieces: [] },
              { number: 5, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 'bar', to: 1}, {from: 1, to: 3} ] }

        it 'must have empty bar error' do
          game.move(player, list)
          refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::EmptyBarError) }
        end
      end
    end

    describe 'to off the board' do
      describe 'with a valid move' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 21, pieces: [{owner: 1}] },
              { number: 22, pieces: [] },
              { number: 23, pieces: [{owner: 1}] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 23, to: 'off_board'}, {from: 21, to: 22} ] }

        it 'must not have error' do
          game.move(player, list)
          assert_empty game.errors
        end
      end

      describe 'with both off board' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 4 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 21, pieces: [{owner: 1}] },
              { number: 22, pieces: [] },
              { number: 23, pieces: [{owner: 1}] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 23, to: 'off_board'}, {from: 21, to: 'off_board'} ] }

        it 'must not have error' do
          game.move(player, list)
          assert_empty game.errors
        end
      end

      describe 'without dice matching' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 20, pieces: [{owner: 1}] },
              { number: 21, pieces: [] },
              { number: 22, pieces: [{owner: 1}] },
              { number: 23, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 22, to: 'off_board'}, {from: 20, to: 21} ] }

        it 'must have a dice mismatch error' do
          game.move(player, list)
          refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::DiceMismatchError) }
        end
      end

      describe 'with the dice larger than the back point' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 6 },
              { number: 5 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 20, pieces: [{owner: 1}] },
              { number: 21, pieces: [] },
              { number: 22, pieces: [{owner: 1}] },
              { number: 23, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 20, to: 'off_board'}, {from: 22, to: 'off_board'} ] }

        it 'must not have a dice mismatch error' do
          game.move(player, list)
          assert_nil game.errors.find { |n| n.instance_of?(JustBackgammon::DiceMismatchError) }
        end
      end

      describe 'while pieces are still home' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 1 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 12, pieces: [{owner: 1}] },
              { number: 21, pieces: [{owner: 1}] },
              { number: 22, pieces: [] },
              { number: 23, pieces: [{owner: 1}] }
            ],
            off_board: { pieces: [] }
          })
        }
        let(:list) { [ {from: 23, to: 'off_board'}, {from: 21, to: 22} ] }

        it 'must have a bear off error' do
          game.move(player, list)
          refute_nil game.errors.find { |n| n.instance_of?(JustBackgammon::BearOffError) }
        end
      end

      describe 'with some moves off board and some not' do
        let(:game) {
          JustBackgammon::GameState.new({
            current_player_number: 1,
            current_phase: 'move',
            dice: [
              { number: 6 },
              { number: 2 }
            ],
            bar: { pieces: [] },
            points: [
              { number: 18, pieces: [{owner: 1}] },
              { number: 19, pieces: [{owner: 1}] },
              { number: 20, pieces: [] }
            ],
            off_board: { pieces: [] }
          })
        }

        let(:list) { [ {from: 18, to: 20}, {from: 19, to: 'off_board'} ] }

        it 'must not have error' do
          game.move(player, list)
          assert_empty game.errors
        end
      end
    end
  end

  describe 'winner' do
    describe 'with a game where a player has 15 pieces off board' do
      it 'must have the player as the winner' do
        assert_equal 1, winning_game.winner
      end
    end

    describe 'with a game where no player has 15 pieces off board' do
      it 'must have no player as the winner' do
        assert_equal nil, game_in_roll_phase.winner
      end
    end
  end

  describe 'as json' do
    let(:game_state) { JustBackgammon::GameState.default }
    let(:json) {
      { current_player_number: 1,
        current_phase: "roll",
        dice: [
          { number: nil },
          { number: nil }
        ],
        bar: { pieces: [] },
        points: [
          { number: 1, pieces: [ { owner: 1 }, { owner: 1 } ] },
          { number: 2, pieces: [] },
          { number: 3, pieces: [] },
          { number: 4, pieces: [] },
          { number: 5, pieces: [] },
          { number: 6, pieces: [ { owner: 2 }, { owner: 2 }, { owner: 2 }, { owner: 2 }, { owner: 2 } ] },
          { number: 7, pieces: [] },
          { number: 8, pieces: [ { owner: 2 }, { owner: 2 }, { owner: 2 } ] },
          { number: 9, pieces: [] },
          { number: 10, pieces: [] },
          { number: 11, pieces: [] },
          { number: 12, pieces: [ { owner: 1 }, { owner: 1 }, { owner: 1 }, { owner: 1 }, { owner: 1 } ] },
          { number: 13, pieces: [ { owner: 2 }, { owner: 2 }, { owner: 2 }, { owner: 2 }, { owner: 2 } ] },
          { number: 14, pieces: [] },
          { number: 15, pieces: [] },
          { number: 16, pieces: [] },
          { number: 17, pieces: [ { owner: 1 }, { owner: 1 }, { owner: 1 }, ] },
          { number: 18, pieces: [] },
          { number: 19, pieces: [ { owner: 1 }, { owner: 1 }, { owner: 1 }, { owner: 1 }, { owner: 1} ] },
          { number: 20, pieces: [] },
          { number: 21, pieces: [] },
          { number: 22, pieces: [] },
          { number: 23, pieces: [] },
          { number: 24, pieces: [ { owner: 2 }, { owner: 2 } ] }
        ],
        off_board: { pieces: [] }
      }
    }

    it 'must serialize the board' do
      assert_equal json, game_state.as_json
    end
  end
end