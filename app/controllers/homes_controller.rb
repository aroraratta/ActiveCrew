class HomesController < ApplicationController
  def top
    @words = [
  "世界がぜんたい幸福にならないうちは、。個人の幸福はあり得ない。宮沢賢治",
  "友情とは二つの体に宿る一つの魂である。。Aristotles",
  "光の中を一人で歩くよりも、。闇の中を友人とともに歩くほうがいい。Helen Keller",
  "いかなる財宝とくらべようとも、。良友にまさるものはないではないか。Socrates",
  "苦しみをともにするのではなく、。喜びをともにすることが友人をつくる。Friedrich Wilhelm Nietzsche",
  "友の幸福のためにどれだけ尽くしているか、。そこに人間の偉大さを測る物差しがある。Mahatma Gandhi"
]
    @random_word = @words.sample
    @lines = @random_word.split("。")
  end

  def about
  end
end
