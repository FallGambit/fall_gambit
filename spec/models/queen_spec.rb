require 'rails_helper'

RSpec.describe Queen, type: :model do
  describe "#valid_move?" do
    context "diagonal moves" do
      it "passes +X +Y no obstruction no end piece" do

      end
      it "passes +X -Y no obstruction no end piece" do

      end
      it "passes -X -Y no obstruction no end piece" do

      end
      it "passes -X +Y no obstruction no end piece" do

      end
      it "passes +X +Y no obstr opposite color end piece" do

      end
      it "passes +X -Y no obstr opposite color end piece" do

      end
      it "passes -X -Y no obstr opposite color end piece" do

      end
      it "passes -X +Y no obstr opposite color end piece" do

      end
      it "fails +X +Y no obstr same color end piece" do

      end
      it "fails +X -Y no obstr same color end piece" do

      end
      it "fails -X -Y no obstr same color end piece" do

      end
      it "fails -X +Y no obstr same color end piece" do

      end
      it "fails +X +Y with obstruction" do

      end
      it "fails +X -Y with obstruction" do

      end
      it "fails -X -Y with obstruction" do

      end
      it "fails -X +Y with obstruction" do

      end
    end

    context "horizontal moves" do
      it "passes +Y no obstruction no end piece" do

      end
      it "passes -Y no obstruction no end piece" do

      end
      it "passes +Y no obstr opposite color end piece" do

      end
      it "passes -Y no obstr opposite color end piece" do

      end
      it "fails +Y no obstr same color end piece" do

      end
      it "fails -Y no obstr same color end piece" do

      end
      it "fails +Y with obstruction" do

      end
      it "fails -Y with obstruction" do

      end
    end

    context "vertical moves" do
      it "passes +X no obstruction no end piece" do

      end
      it "passes -X no obstruction no end piece" do

      end
      it "passes +X no obstr opposite color end piece" do

      end
      it "passes -X no obstr opposite color end piece" do

      end
      it "fails +X no obstr same color end piece" do

      end
      it "fails -X no obstr same color end piece" do

      end
      it "fails +X with obstruction" do

      end
      it "fails -X with obstruction" do

      end
    end
  end
end
