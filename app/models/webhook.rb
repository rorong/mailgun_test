class Webhook < ApplicationRecord
  serialize :data, Hash
end
