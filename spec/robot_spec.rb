# FROZEN_STRING_LITERAL: true

require_relative '../robot'

RSpec.describe Robot do
  describe '.read_instructions' do
    context 'when using the provided instructions.txt file' do
      it 'reads the instruction file and creates a Robot' do
        expect(Robot.read_instructions).to be_a Robot
      end
    end

    context 'when using another valid instruction file' do
      it 'reads the instruction file and creates a Robot' do
        expect(Robot.read_instructions('extra_valid_instructions.txt')).to be_a Robot
      end
    end

    context 'when using another valid instruction file' do
      it 'reads the instruction file and creates a Robot' do
        expect(Robot.read_instructions('extra_valid_instructions_2.txt')).to be_a Robot
      end
    end

    context 'when using an invalid instruction file' do
      it 'raises an error' do
        expect { Robot.read_instructions('invalid_instructions_1.txt') }.to raise_exception(InvalidPlacementError)
      end
    end

    context 'when using an instruction file without a valid placement' do
      it 'raises an error' do
        expect { Robot.read_instructions('invalid_instructions_1.txt') }.to raise_exception(InvalidPlacementError)
      end
    end
  end

  describe '#go' do
    let(:instructions) do
      [
        'PLACE 0,0,NORTH',
        'MOVE',
        'REPORT'
      ]
    end

    let(:robot) { Robot.new(instructions) }

    before do
      allow($stdout).to receive(:puts).and_call_original
    end

    it 'prints to STDOUT' do
      robot.go

      expect($stdout).to have_received(:puts).with('0,1,NORTH')
    end

    it 'has the correct attributes' do
      robot.go

      expect(robot.x).to eq 0
      expect(robot.y).to eq 1
      expect(robot.direction).to eq 'NORTH'
    end

    context 'when the robot is rotated' do
      context 'when the robot is rotated left' do
        let(:instructions) do
          super() + ['LEFT']
        end

        it 'has the correct attributes' do
          robot.go

          expect(robot.x).to eq 0
          expect(robot.y).to eq 1
          expect(robot.direction).to eq 'WEST'
        end
      end

      context 'when the robot is rotated right' do
        let(:instructions) do
          super() + ['RIGHT']
        end

        it 'has the correct attributes' do
          robot.go

          expect(robot.x).to eq 0
          expect(robot.y).to eq 1
          expect(robot.direction).to eq 'EAST'
        end
      end
    end

    context 'when the robot is moved' do
      let(:instructions) do
        super() + %w[MOVE MOVE MOVE REPORT]
      end

      it 'has the correct attributes' do
        robot.go

        expect(robot.x).to eq 0
        expect(robot.y).to eq 4
        expect(robot.direction).to eq 'NORTH'
      end

      context 'when the robot is attempted to be moved off the table' do
        context 'and the y value would be too large' do
          let(:instructions) do
            super() + %w[MOVE MOVE MOVE MOVE MOVE MOVE REPORT]
          end

          it 'ignores the moves that are not valid' do
            robot.go

            expect(robot.x).to eq 0
            expect(robot.y).to eq 5
            expect(robot.direction).to eq 'NORTH'
          end
        end

        context 'and the y value would be too small' do
          let(:instructions) do
            super() + %w[RIGHT RIGHT MOVE MOVE MOVE MOVE MOVE MOVE REPORT]
          end

          it 'ignores the moves that are not valid' do
            robot.go

            expect(robot.x).to eq 0
            expect(robot.y).to eq 0
            expect(robot.direction).to eq 'SOUTH'
          end
        end

        context 'and the x value would be too large' do
          let(:instructions) do
            super() + %w[RIGHT MOVE MOVE MOVE MOVE MOVE MOVE REPORT]
          end

          it 'ignores the moves that are not valid' do
            robot.go

            expect(robot.x).to eq 5
            expect(robot.y).to eq 4
            expect(robot.direction).to eq 'EAST'
          end
        end

        context 'and the x value would be too small' do
          let(:instructions) do
            super() + %w[LEFT MOVE MOVE REPORT]
          end

          it 'ignores the moves that are not valid' do
            robot.go

            expect(robot.x).to eq 0
            expect(robot.y).to eq 4
            expect(robot.direction).to eq 'WEST'
          end
        end
      end
    end

    context 'when the robot is placed again' do
      context 'when the subsequent placement is valid' do
        let(:instructions) do
          super() + ['PLACE 3,3,WEST', 'REPORT']
        end

        it 'ignores the invalid placement and retains the correct attributes' do
          robot.go

          expect(robot.x).to eq 3
          expect(robot.y).to eq 3
          expect(robot.direction).to eq 'WEST'
        end
      end

      context 'when the subsequent placement is invalid' do
        context 'when the values are too large' do
          let(:instructions) do
            super() + ['PLACE 6,6,SOUTH', 'REPORT']
          end

          it 'ignores the invalid placement and retains the correct attributes' do
            robot.go

            expect(robot.x).to eq 0
            expect(robot.y).to eq 1
            expect(robot.direction).to eq 'NORTH'
          end
        end

        context 'when the values are negative' do
          let(:instructions) do
            super() + ['PLACE -1,-1,SOUTH', 'REPORT']
          end

          it 'ignores the invalid placement and retains the correct attributes' do
            robot.go

            expect(robot.x).to eq 0
            expect(robot.y).to eq 1
            expect(robot.direction).to eq 'NORTH'
          end
        end
      end
    end
  end
end
