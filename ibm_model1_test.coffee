'use strict';
assert = require('assert')
ibm1 = require('./ibm_model1')

assert.ok(ibm1);


model = new ibm1
assert.deepEqual(model.preprocess_tag(['aあ', '2aテスト']), ['Aあ', '2Aテスト', 'NULLTAG']);
assert.deepEqual(model.preprocess_tag(['aあ', '2aテスト']), ['Aあ', '2Aテスト', 'NULLTAG']);

corpus1 = [[['aaa', '2aAA'], ['aaa', '2zzzA']]]
model.preprocess(corpus1)
assert.deepEqual(corpus1, [[['AAA', '2AAA', 'NULLTAG'], ['AAA', '2ZZZA', 'NULLTAG']]])

model.countOne([['test11'], ['test12']])
pair1 = {
    'TEST11 TEST12': 1,
    'TEST11 NULLTAG': 1,
    'NULLTAG TEST12': 1,
    'NULLTAG NULLTAG': 1
}
assert.deepEqual(model.pair, pair1)

model.countAll([[['aaa', '2aAA'], ['aaa', '2zzzAA']]])
pair2 = {
    'TEST11 TEST12': 1,
    'TEST11 NULLTAG': 1,
    'NULLTAG TEST12': 1,
    'NULLTAG NULLTAG': 2,
    'AAA AAA': 1,
    'AAA 2ZZZAA': 1,
    'AAA NULLTAG': 1,
    '2AAA AAA': 1,
    '2AAA 2ZZZAA': 1,
    '2AAA NULLTAG': 1,
    'NULLTAG AAA': 1,
    'NULLTAG 2ZZZAA': 1
}
assert.deepEqual(model.pair, pair2)

model.train(1)
assert.strictEqual('TEST11', model.suggest(['test12'])[0][0])

corpus2 =  [
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'Fate/Zero', 'Fate/Zero100users入り', 'type-moon', 'セイバー', '良い足だ…', ],
  ],
  [
    [ '東方き-霧雨魔理沙', '東方あ-アリス・マーガトロイド', '東方ぱ-パチュリー・ノーレッジ', ],
    [ 'c81', 'だめだこいつらはやくなんとかしないと', 'なにこれかわいい', 'まりちゃん総受け', '二人ともよだれふけ', '東方', '漫画', '魔理ちゃん', '魔理沙', ],
  ],
  [
    [ '化物語', ],
    [ '偽物語', '化物語', '落書き', '阿良々木月火', '阿良々木火憐', ],
  ],
  [
    [ '東方ひ-比那名居天子', ],
    [ 'おい、デュエルしろよ', 'ドン☆', '勝てる気がしない', '千年パズル', '天子', '東方', '東方Project250users入り', '緋想の剣', '遊戯王', '非想非非想天の娘', ],
  ],
  [
    [ '東方ひ-比那名居天子', '東方や-八雲紫', ],
    [ 'てんこ', 'なにこれすごくかっこいい', 'ゆかてん', '八雲紫', '勝てる気がしない', '東方', '東方Project100users入り', '比那名居天子', '溢れ出るカリスマ', '眼力', ],
  ],
  [
    [ '東方な-永江衣玖', '東方ひ-比那名居天子', ],
    [ 'なにこれかっこいい', '勝てる気がしない', '天衣無縫', '東方Project1000users入り', '東方緋想天', '比那名居天子', '永江衣玖', '溢れ出るカリスマ', '緋想の剣', '芸術', ],
  ],
  [
    [ '東方ひ-比那名居天子', ],
    [ 'Asagiのおかげで完成した天子', '天子', '尻神様', '東方', '東方Project500users入り', '水着', '目の保養向きのイラスト', '非想非非想天の娘', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ '白レン', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON-レン', ],
    [ 'R-18', 'TYPE-MOON', '白レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'クールビズ', 'メルブラ', '白レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'メルブラ', '白レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'タイプムーンエース5', 'レン', '月姫', '黒レン', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON-レン', ],
    [ 'R-18', 'つるぺた', 'ぶっかけ', 'フェラ', 'メルティブラッド', 'レン', 'ロリ', '射精', '月姫', '黒レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'おしっこ我慢', 'ドSホイホイ', 'メルブラ', '七夜「悪いね☆」', '恐らく中には青子さん', '白レン', '白レン普及委員会', '続きを期待せざるを得ない', ],
  ],
  [
    [ '黒髪ロング', '涙', ],
    [ 'どう足掻いても、現実', 'ふともも', 'オリジナル', '失禁差分があるはず', '女の子', '泣き顔', '黒髪', ],
  ],
  [
    [ '黒髪ロング', '涙', ],
    [ '泣き顔', '练习', '黒髪ロング', ],
  ],
  [
    [ '涙', ],
    [ 'あなたがかわいすぎて生きるのがつらいんだ', 'ありません', 'カーバイラスト', '一迅社文庫', '別れる理由を述べなさい!', '涙目', ],
  ],
  [
    [ '東方ひ-比那名居天子', '涙', '0_お気に入り', ],
    [ 'なにこれかわいい', 'もっと泣かせるべき', 'ドSホイホイ', '左下に泣かせた犯人', '東方', '東方Project1000users入り', '比那名居天子', '泣いた天人', '泣き顔', ],
  ],
  [
    [ 'VOCALOID', '涙', ],
    [ 'VOCALOID', 'VOCALOID100users入り', 'そしてこのプロフ絵である', 'ふつくしい', 'リアル系', '初音ミク', '涙', ],
  ],
  [
    [ '涙', ],
    [ 'オリジナル', '落書き', ],
  ],
  [
    [ '涙', ],
    [ 'めそめそさん', 'ロリ', '彼岸花の咲く夜に', '森谷毬枝', ],
  ],
  [
    [ '涙', ],
    [ 'ふつくしい', 'オリジナル500users入り', 'ハイセンス', '女の子', ],
  ],
  [
    [ 'VOCALOID', '涙', ],
    [ 'Vocaloid', 'ボーカロイド', '初音ミク', '涙', '爽やかなミク歌', ],
  ],
  [
    [ '東方い-犬走椛', '涙', ],
    [ 'なでなで', '上目遣い', '東方', '犬走椛', ],
  ],
  [
    [ '涙', '黒髪ロング', ],
    [ 'いじめられっ子', 'そしてこの背景である', 'オリジナル', 'セーラー服', 'ドSホイホイ', '叩かれたくなかったら俺と付き合うんだな!', '女の子', '意外に紳士なアンケート結果', '泣き顔', ],
  ],
  [
    [ '' ],
    [ 'C81', 'ナプキンポーチ', 'ブルマ', '階段', ],
  ],
  [
    [ '' ],
    [ 'sprite', '恋と選挙とチョコレート', '青海衣更', ],
  ],
  [
    [ '' ],
    [ 'c81', 'なにこれ綺麗', 'ふつくしい', 'オリジナル', 'オリジナル1000users入り', 'クリスマス', 'ハイセンス', 'マジ天使', '天使', ],
  ],
  [
    [ '' ],
    [ '尻神様', '戦コレ英雄', ],
  ],
  [
    [ '' ],
    [ 'QUEENSAXE', 'おっぱい', 'むちむち', 'アイシャ', 'クリック推奨', 'ハイレグ', 'レオタード', '女の子', '巨乳', '極上の乳', ],
  ],
  [
    [ '' ],
    [ 'ふつくしい', 'オリジナル', 'オリジナル500users入り', 'ハイセンス', '近未来', ],
  ],
  [
    [ '' ],
    [ 'C81', 'オリジナル', '冬コミ', '履いてないと嬉しい', '撫で回したい太もも', '青山澄香', ],
  ],
  [
    [ '' ],
    [ 'C81', 'オリジナル', '創作', '女の子', ],
  ],
  [
    [ '風景', ],
    [ 'うつくしすぎる', 'かっぱえびせん', 'はいてない', '女の子', '猫', '箱根登山鉄道', '紫陽花', '鉄壁スカート', '鉄道', '電車', ],
  ],
  [
    [ '風景', ],
    [ 'C81', 'なにこれ切ない', 'ふつくしい', 'オリジナル', 'オリジナル1000users入り', '夕焼け', '女の子', '教室', ],
  ],
  [
    [ '風景', ],
    [ 'オリジナル', ],
  ],
  [
    [ '東方き-霧雨魔理沙', '風景', ],
    [ 'ありがとうございました', 'なにこれかっこいい', '八咫烏', '東方', '東方Project250users入り', '霊烏路空', '霊知の太陽信仰', '霧雨魔理沙', ],
  ],
  [
    [ '東方ひ-比那名居天子', '東方な-永江衣玖', '風景', ],
    [ 'ふつくしい', 'ハイセンス', '二人の旅', '天子', '東方Project1000users入り', '短髪天子', '衣玖', '鳥がイケメン', ],
  ],
  [
    [ '風景', '亜人', ],
    [ 'ええまぁ', 'くろいの', 'オリジナル', 'オリジナル5000users入り', 'メイキング希望', '桃山つつね', '狐耳', '白玉きつね', ],
  ],
  [
    [ '風景', ],
    [ '創作', '女の子', '雨宿り', ],
  ],
  [
    [ '風景', ],
    [ 'R-15', 'オリジナル', 'クリック推奨', 'ネコミミ', 'メカ?', 'ロリ', ],
  ],
  [
    [ 'R-18', 'シュタインズゲート', ],
    [ 'R-18', 'Steins;Gate', 'steins;gate100users入り', 'おっぱい', 'まゆしぃ☆', 'テープくばぁ', '巨乳', '抱き枕', '椎名まゆり', '爆乳', ],
  ],
  [
    [ 'シュタインズゲート', ],
    [ 'Steins;Gate', 'STEINS;GATE', 'steins;gate100users入り', 'オカリンホイホイ', 'パンスト', 'ロリコンホイホイ', 'ロリスティーナ', '幼女しゅ', '牧瀬紅莉栖', '目から汗', ],
  ],
  [
    [ 'シュタインズゲート', ],
    [ 'Steins;Gate', 'シュタインズ・ゲート', '牧瀬紅莉栖', ],
  ],
  [
    [ 'R-18', 'シュタインズゲート', ],
    [ 'R-18', 'Steins;Gate', 'steins;gate100users入り', 'steins;gate500users入り', 'おっぱい', 'へそ', '巨乳', '極上の乳', '牧瀬紅莉栖', '逆光', ],
  ],
  [
    [ '黒髪ロング', 'アトリエ', ],
    [ 'トトリのアトリエ', 'ミミ', 'ミミ・ウリエ・フォン・シュヴァルツラング', '黒髪ロング', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'トトリのアトリエ', 'メルルのアトリエ', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'アトリエシリーズ', 'メルル', 'メルルのアトリエ', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'メルルのアトリエ', 'メルルリンス・レーデ・アールズ', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'トトリのアトリエ', 'ミミ', 'ミミ・ウリエ・フォン・シュヴァルツラング', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'きっと合体してるよね', 'これ絶対入ってるよね', 'アトリエシリーズ1000users入り', 'トトミミ', 'トトリ', 'プロレスごっこ', 'ミミ', 'メルルのアトリエ', '混ざりたい', '百合', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'トトリのアトリエ', 'ミミちゃんに定評のあるマロミ', 'ミミ・ウリエ・フォン・シュヴァルツラング', 'メルルのアトリエ', ],
  ],
  [
    [ 'アトリエ', ],
    [ 'C81', 'ホム', 'メルルのアトリエ', ],
  ],
  [
    [ '白髪', ],
    [ 'オリジナル', 'オリジナル100users入り', '冬景色', '和風', '白髪', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'アナザーブラッド', 'デモンベイン', 'ニトロプラス', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'ルイリー', '孔瑞麗', '鬼哭街', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'ニトロプラス', 'ペトルーシュカ', '兄さん「こんななりでも妹(の一部)なんです……」', '尻神様', '油断してるとグロ変形!', '油断すると(プレイヤーの心に)トラウマ', '版権', '鬼哭街', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'ふつくしい', '鬼哭街', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'アナザーブラッド', 'デモンベイン', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'アナザーブラッド', 'デモンベイン', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'アル・アジフ', 'デモンベイン', 'ニトロプラス', '女の子', '尻神様', '版権', ],
  ],
  [
    [ 'ニトロプラス', ],
    [ 'ペトルーシュカ', '鬼哭街', ],
  ],
  [
    [ '白髪', ],
    [ 'Pandora100users入り', 'PandoraHearts', 'ふつくしい', 'アリス', 'アヴィスの意思', 'パンドラハーツ', '見えない…だと', ],
  ],
  [
    [ '白髪', ],
    [ 'c81', 'オリジナル', ],
  ],
  [
    [ 'SoundHorizon', '白髪', ],
    [ 'SoundHorizon', 'SoundHorizon100users入り', 'ふつくしい', 'アルビノ', 'メイキング希望', 'ラフレンツェ', ],
  ],
  [
    [ '白髪', ],
    [ 'アルビノ', 'オリジナル', 'オリジナル100users入り', 'クリック推奨', '赤目', '銀髪', ],
  ],
  [
    [ 'R-18', '白髪', ],
    [ 'DR23', 'R-18', 'おっぱい', 'ふつくしい', 'アルビノ少女', 'エロ衣装', 'オリジナル', 'オリジナル1000users入り', '極上の乳', ],
  ],
  [
    [ '白髪', ],
    [ 'ふつくしい', 'アルビノ', 'オリジナル', 'オリジナル1000users入り', 'ストライプ', 'ドロワーズ', 'ロリィタファッション', 'ロリータ', '口隠し', '少女', ],
  ],
  [
    [ '東方れ-霊烏路空', '白髪', ],
    [ 'まるでラスボスのようだ', 'アルビノ', 'リオレウス', '東方', '白鴉', '霊烏路空', '霊知の太陽信仰～Nuclear_Fusion', '鴉から鳩', ],
  ],
  [
    [ '亜人', '白髪', ],
    [ 'アルビノ', 'クリック推奨', '創作', '女の子', '着物', '足袋', '鬼', ],
  ],
  [
    [ 'VOCALOID', '白髪', ],
    [ 'VOCALOID', 'アルビノ', '巡音ルカ', ],
  ],
  [
    [ '白髪', ],
    [ 'アルビノ', 'オリジナル', 'ロリ巨乳', '和服', '女の子', ],
  ],
  [
    [ '白髪', ],
    [ 'アルビノ', 'オリキャラ', '妄想惑星', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'むしろ腿がイイ', 'アクエリアンエイジ', 'オリジナル1000users入り', 'クリック推奨', '俺には見える!', '天使', '女の子', '実は見えたと思ったのは足の隙間', '数ドット見える!', '見えそうで見えない', ],
  ],
  [
    [ '講座・メイキング', '0_お気に入り', ],
    [ 'GAINGAUGE', 'なるほどよく分からん', 'オリジナル', 'オリジナル5000users入り', 'メイキング', '原画からして違う', '講座', '講座1000users入り', ],
  ],
  [
    [ 'R-18G', '黒髪ロング', '0_お気に入り', '' ],
    [ 'R-18G', 'すごすぎて笑っちゃう', 'ふたなり', 'もうなにがなんだか', 'ダイエット支援絵', '一周してかわいい', '寄生', '異形', '虫', '蟲', ],
  ],
  [
    [ '東方み-水橋パルスィ', '0_お気に入り', '' ],
    [ 'こっちみろ', 'ふつくしい', 'らくがき', 'パルスィ', '地殻の下の嫉妬心', '地霊殿', '東方', '橋姫', '水橋', '水橋パルスィ', ],
  ],
  [
    [ '東方ふ-フランドール・スカーレット', '0_お気に入り', ],
    [ 'フランドール', '勝てる気がしない', '吸血鬼', '妹様', '悪魔の妹', '東方', '東方Project1000users入り', '溢れ出るカリスマ', '紅い狂喜', ],
  ],
  [
    [ '東方や-橙', '0_お気に入り', ],
    [ '東方', '東方Project500users入り', '橙', '美猫', ],
  ],
  [
    [ '0_お気に入り', '獣耳', ],
    [ 'C77', 'Quadruple', 'ぬこ', 'オリジナル', 'オリジナル1000users入り', 'クリック推奨', 'ネコマタ', '三杯酢', '晩杯酢', '鈴が通る', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'クトゥルフ', 'ネクロノミカン', 'ネクロノミコン', '魔道書', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'クリック推奨', 'スペルカード', '冬幻鏡', '幻想鏡現詩', '慧音', '東方', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'そしてこのプロフ絵である', 'ふつくしい', 'スペルカード', '八坂神奈子', '幻想鏡現詩', '東方', '東方Project1000users入り', '東風谷早苗', '洩矢諏訪子', '蛇符「神代大蛇」', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'せんとさん', 'ふつくしい', '女の子', '女性', ],
  ],
  [
    [ '0_お気に入り', 'TYPE-MOON-間桐桜', ],
    [ 'fate', 'fate/zero', 'Fate/Zero1000users入り', 'なにこれ素敵', '一粒で二度哀しい', '間桐桜', '雁夜おじさんの手…', '雁桜', '黒桜', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'オリジナル1000users入り', 'クリック推奨', 'ハイセンス', '人外', '人魚', '和風', '妖艶', '湯女', '空白の美', '見世物小屋', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'DIO', 'Twitpic', 'ごまどか', 'アトラク=ナクア', 'サモンナイト2', 'スク水', 'ツイピク', 'ドッペルゲンガーアルル', 'ビックバイパー', '素晴らしい', ],
  ],
  [
    [ '0_お気に入り', ],
    [ '蛇', ],
  ],
  [
    [ '0_お気に入り', ],
    [ '冬幻鏡', '勝てる気がしない', '博麗霊夢', '幻想鏡現詩', '東方Project500users入り', '霊烏路空', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'c81', 'ふつくしい', 'メイキング希望', 'レミリア・スカーレット', 'レミ咲', '十六夜咲夜', '手と手', '東方', '東方CDジャケット', '東方Project250users入り', ],
  ],
  [
    [ '0_お気に入り', ],
    [ '10点じゃ足りない', 'なにこれきれい', 'ふつくしい', 'オリジナル', 'オリジナル5000users入り', 'クリック推奨', 'ハイセンス', 'フリル地獄', '女の子', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'w', 'ぱんつこわい', 'クリック推奨', 'デフェンスに定評のない草', 'パンチラ', '多々良小傘', '小傘', '東方', '東方Project500users入り', '栗みたいな口', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'しっぽ', 'もふりたい尻尾', 'オリジナル', 'ストッキング越しのパンツ', 'パンスト越しのパンツ', '狐耳', '縦セタ', '赤眼鏡', '黒タイツ', ],
  ],
  [
    [ '' ],
    [ 'POPSENSE', 'オリジナル', 'ゼンハ', '冬コミ', ],
  ],
  [
    [ '' ],
    [ 'つまりスタバイオリン', 'オリジナル', 'スタバイオリン', 'ヴァイオリン', '略してスタバ', ],
  ],
  [
    [ '' ],
    [ 'C81', 'ふつくしい', 'オリジナル', 'チャクラム', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'fate/zero', 'セイバー', ],
  ],
  [
    [ '東方', ],
    [ 'クリック推奨', 'フランドール', '咲夜', '東方', '紅魔館', ],
  ],
  [
    [ '東方', ],
    [ 'アリぱい', 'リメイクする度に凶悪度UP', 'リメイクのリメイク', 'リメイクの度に大きくなる絵', '勝てる気がしない', '地霊殿魔理沙組', '本当は怖い幻想郷', '東方', '魔理沙_にとり_アリス_パチュリー', ],
  ],
  [
    [ '東方', ],
    [ 'テレビ東方', 'ループし続けた結果がこの年れ…うわなにを(ry', '八坂神奈子', '八意永琳', '八雲紫', '少女ってレベルじゃない', '東方', '東方五大老', '聖白蓮', '西行寺幽々子', ],
  ],
  [
    [ 'R-18', '東方', '悪堕ち', ],
    [ 'R-18', '堕霊歌', '描いてもいいのよ', '東方', '東方悪堕ち', '牙', '裏・東方紅魔郷', '裏・東方紅魔郷IF', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'くぱぁ', 'キュアミューズ', 'スイートプリキュア♪', 'ロリビッチ', '寝取られ', '洗脳', '淫語', '溢れ精液', '調辺アコ', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'おっぱい', 'ウサ子さん', 'オリジナル', 'ピアス', '変身ヒロイン', '巨乳', '悪堕ち', '食い込み', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'アンケートに全部の選択肢がない', 'ボテ腹', '寄生', '巫女', '悪堕ち', '続編希望', '苗床', '触手', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'おちんちん', 'ふたなり', '堕霊歌', '悪堕ち', '東方悪堕ち', '極上の竿', '裏・東方紅魔郷', ],
  ],
  [
    [ '悪堕ち', ],
    [ 'Fate', 'アホ毛のないほう', 'オルタ', 'セイバー', 'セイバーオルタ', '少し大きめの絵', '暴☆食☆王', '黒セイバー', ],
  ],
  [
    [ '悪堕ち', ],
    [ 'calibur', '勝利すべき黄金の剣', '洞穴', '選定の剣', '金瞳', '黑', '黒セイバー', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'ふたなり', 'ネコスーツ', 'ボディスーツ', '悪堕ち', '続編希望', '触手', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'R-18', 'お漏らし', 'オリジナル', 'レイプ目', '前から見えるお尻', '失禁', '姫', '巨乳', '悪堕ち', '洗脳', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'NTR', 'R-18', '中出し', '乳首ピアス', '六道本山の巫女', '寝取られ', '巫女', '悪堕ち', '洗脳', '異種姦', ],
  ],
  [
    [ '悪堕ち', '魔法少女まどか☆マギカ', ],
    [ 'お待ちしてました!', 'なにこれかっこいい', 'ふつくしい', 'まどか☆マギカ1000users入り', '悪堕ち', '斬られたい', '美樹さやか', '違和感仕事しろ', '魔法少女まどか☆マギカ', '黒魔法少女', ],
  ],
  [
    [ '悪堕ち', '魔法少女まどか☆マギカ', ],
    [ 'なにこれかっこいい', 'ふつくしい', 'まどか☆マギカ1000users入り', '佐倉杏子', '勝てる気がしない', '悪堕ち', '暗子', '魔法少女まどか☆マギカ', '黒魔法少女', ],
  ],
  [
    [ '悪堕ち', 'プリキュア', ],
    [ 'キュアメロディ', 'スイプリ100users入り', 'スイートプリキュア', 'スイートプリキュア♪', 'ノワールプリキュア', '北条響', '寝不足', '悪堕ち', '洗脳', ],
  ],
  [
    [ '悪堕ち', ],
    [ 'アサシン', 'オリジナル', 'ファンタジー', 'ボンデージ', '女の子', '悪堕ち', ],
  ],
  [
    [ 'R-18', '悪堕ち', ],
    [ 'NTR', 'R-18', 'アヘ顔ダブルピース', 'ピアス', 'ボンデージ', '六道本山の巫女', '寝取られ', '巫女', '悪堕ち', '洗脳', ],
  ],
  [
    [ '獣耳', ],
    [ 'C81', 'オリジナル', '狐耳', '腋', ],
  ],
  [
    [ '獣耳', ],
    [ 'なにこれかわいい', 'むしろ描いてください', 'らくがき', 'オリジナル', 'オリジナル500users入り', 'ケモミミ', '一般人の落書きと違う', '名前を知りたい', '真赭(まそほ)', ],
  ],
  [
    [ '獣耳', ],
    [ 'けもみみ', 'つるはいずこに', 'オリジナル', 'オリジナル500users入り', 'メイキング希望', '眼鏡', '黒ハイ', ],
  ],
  [
    [ 'R-18', '獣耳', ],
    [ 'C80', 'R-18', 'しっぽリボン', 'ショコラ&バニラ', '尻神様', '掴みたい尻尾', '極上の貧乳', '猫耳', '見え隠れするショコラのスージーさん', '貧乳', ],
  ],
  [
    [ '獣耳', ],
    [ 'C80', 'しっぽリボン', 'とらのあな予約再開希望', 'なにこれ素敵', 'クリック推奨', 'ショコラ&バニラ', '掴みたい尻尾', '猫耳', ],
  ],
  [
    [ '獣耳', ],
    [ 'オリジナル', '一号', '女の子', '狐娘', '獣耳', '練習', '落書き', ],
  ],
  [
    [ '獣耳', ],
    [ '女の子', '狐娘', '獣耳', '落書き', '雪', ],
  ],
  [
    [ '獣耳', ],
    [ 'C81', 'オリジナル', '狐耳', '腋', ],
  ],
  [
    [ '獣耳', ],
    [ 'オリジナル', '狐耳', '黒髪ロング', ],
  ],
  [
    [ '獣耳', ],
    [ 'オリジナル', '待ってました!!', '浴衣', '狐耳', ],
  ],
  [
    [ '獣耳', ],
    [ 'おっぱい', 'オリジナル', 'ショートパンツ', '獣耳', ],
  ],
  [
    [ '獣耳', ],
    [ 'オリジナル', '狐耳', '着物', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'C81', 'Fate', 'Fate/EXTRA', 'TANIMA', 'セイバーブライド', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', 'TYPE-MOON-間桐桜', 'TYPE-MOON', ],
    [ 'C81', 'Fate', 'Fate/Zero', 'Fate/Zero100users入り', '遠坂凛', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'TYPE-MOON', 'セイバー', '戦乙女', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'Fate/Zero', 'Saber', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'Fate/Zero', 'Fate/Zero5000users入り', 'ふつくしい', 'セイバー', 'テライケメン', 'メイキング希望', '約束された勝利の剣', '騎士王', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'Fate/Zero', 'イリヤ', 'ロリヤスフィール・フォン・アインツベルン', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate/Zero', 'Fate/Zero1000users入り', 'ふつくしい・・', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'イリヤ', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'Fate100users入り', 'R-18', 'TYPE-MOON', 'ねこ', 'はいてない', 'イリヤ', 'ネコミミ', 'ロリ', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'Fate/Zero100users入り', 'Fate100users入り', 'イリヤ', 'イリヤスフィール・フォン・アインツベルン', '言峰綺礼', '間桐桜', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'FateZero', 'アイリ', 'アイリスフィール・フォン・アインツベルン', 'イリヤ', 'イリヤスフィール・フォン・アインツベルン', '娘', '本', '母子', '素足', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate', 'Fate100users入り', 'お臍', 'はみパン', 'イリヤ', 'ブルマ', 'ロリ', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'fate', 'type-moon', 'イリヤ', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate/Zero', 'イリヤスフィール・フォン・アインツベルン', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate/Zero', 'Fate/Zero100users入り', 'お持ち帰りしたい!', 'なにこれかわいい', 'なんだただの天使か', 'もうロリコンでいいや', 'らくがき', 'イリヤスフィール・フォン・アインツベルン', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'Fate/Zero', 'Fate/Zero100users入り', 'すろり', 'イリヤ', 'イリヤスフィール・フォン・アインツベルン', ],
  ],
  [
    [ 'TYPE-MOON-イリヤ', ],
    [ 'fate', 'fate/ZERO', 'Fate/Zero100users入り', 'アイリスフィール', 'イリヤ', 'セイバー', '久字舞弥', '夢の構図', '衛宮切嗣', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON', 'TYPE-MOON-間桐桜', ],
    [ 'Fate/zero', 'Fate/Zero100users入り', 'R-18', '尻神様', '間桐桜', '間桐雁夜', ],
  ],
  [
    [ 'TYPE-MOON-間桐桜', ],
    [ 'fate', 'fate/zero', 'Fate/Zero100users入り', 'バーサーカー', '淫蟲', '遠坂葵', '間桐桜', '間桐雁夜', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON-間桐桜', ],
    [ 'R-18', '間桐桜', '黒桜', ],
  ],
  [
    [ 'TYPE-MOON-間桐桜', ],
    [ 'fate/zero', 'Fate/Zero500users入り', 'だが、それがいい', '全部時臣のせい', '桜', '桜ちゃんは何もわるくない!オジサンがわるいんだ;;', '谷間', '間桐桜', ],
  ],
  [
    [ 'TYPE-MOON-間桐桜', 'TYPE-MOON', ],
    [ 'C81', 'Fate', 'Fate100users入り', 'おっぱい', 'ここがエデンか', '乳合わせ', '巨乳', '胸囲の格差社会', '遠坂凛', '間桐桜', ],
  ],
  [
    [ 'R-18', ],
    [ 'R-18', 'おっぱい', 'オリジナル', 'ヴァンパイア', '娼婦', '尻神様', '巨乳', '極上の乳', '輪チラ', ],
  ],
  [
    [ 'R-18', ],
    [ 'C81', 'R-18', '中出し', '僕は友達が少ない', '僕は友達が少ない100users入り', '尻神様', '巨乳', '漫画', '目の中にハート', '肉', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'TYPE-MOON', 'メルブラ', '月姫', '白レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'メルブラ', '白レン', ],
  ],
  [
    [ 'R-18', 'TYPE-MOON-レン', ],
    [ 'R-18', 'すじ', 'メルティブラッド', 'メルブラ', '極上の貧乳', '炉', '白レン', ],
  ],
  [
    [ 'TYPE-MOON-レン', ],
    [ 'Len', 'TypeMoon', '黒レン', ],
  ],
  [
    [ 'TYPE-MOON-両儀式', ],
    [ 'TYPE-MOON', 'Type-Moon', 'typemoon', 'TYPEMOON', '両儀式', '日本刀', '桜', '直死の魔眼', '空の境界', ],
  ],
  [
    [ 'TYPE-MOON-両儀式', ],
    [ 'TYPE-MOON', '両儀式', '空の境界', '美しい', ],
  ],
  [
    [ 'TYPE-MOON-両儀式', ],
    [ 'ふつくしい……', '両儀式', '空の境界', '空の境界100users入り', ],
  ],
  [
    [ 'TYPE-MOON-両儀式', ],
    [ 'TYPE-MOON', '両儀式', '女の子', '桜', '空', '空の境界', '背景', ],
  ],
  [
    [ 'TYPE-MOON-遠野秋葉', ],
    [ 'C81', 'そしてこのプロフ絵である', '前から見えるお尻', '月姫', '秋葉', '遠野秋葉', ],
  ],
  [
    [ 'TYPE-MOON-遠野秋葉', ],
    [ 'ナイチチ', 'メルブラ', '月姫', '遠野秋葉', ],
  ],
  [
    [ 'TYPE-MOON-遠野秋葉', ],
    [ 'MELTYBLOOD', 'TYPE-MOON', '月姬', '遠野秋葉', ],
  ],
  [
    [ 'TYPE-MOON-遠野秋葉', ],
    [ 'おへそ', 'はい、とってもおいしいです。', 'セーラー服', 'メガ秋葉様', '撫で回したいお腹', '月姫', '月姫100users入り', '遠野秋葉', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'CG', 'あきらめたらそこで試合終了ですよ', 'ふつくしい', 'オリジナル1000users入り', 'キャプションで台無し', '女の子', '姫カット', '着物', '黒髪', '黒髪ロング', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'B地区透けてる', 'ドレス', '黒髪', '黒髪ロング', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'オリジナル', '女の子', '少女', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'ふつくしい', '日本鬼子', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'C81', 'オリジナル', 'パンチラ', '冬コミ', '夜景', '尻神様', '履いてなさそうで、ちゃんと履いてる', '撫で回したい太もも', '白峰莉花', '裏腿', ],
  ],
  [
    [ 'R-18', '黒髪ロング', ],
    [ 'R-18', 'ベン・トー', '巨乳', '極上の乳', '白梅梅', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'オリジナル', 'ショートパンツ', '太もも', '戦闘力不明', '白峰莉花', '黒髪ロング', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'オリジナル', 'セーラー服', '黒髪ロング', ],
  ],
  [
    [ '黒髪ロング', ],
    [ '女子高生', '超ロングヘア', '黒髪ロング', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'C81', 'オリジナル', 'パンスト', 'メイキング希望', '制服', '尻神様', '撫で回したい太もも', '眼鏡', ],
  ],
  [
    [ 'R-18', '黒髪ロング', ],
    [ 'R-18', 'おっぱい', '黒髪', ],
  ],
  [
    [ '黒髪ロング', ],
    [ 'ストライプ', 'ハーフコート', 'マフラー', 'ローファー', '乱れ髪', '僕は今日も翻弄される。', '内股', '姉', '黒タイツ', '黒髪ロング', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'Book', 'illustration', 'ふつくしい', 'ソードガールズ', '武器娘', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', '0_お気に入り', ],
    [ 'fate/extra', 'saber', 'ふつくしい', 'クリック推奨', '招き蕩う黄金劇場', '赤セイバー', ],
  ],
  [
    [ '東方こ-東風谷早苗', ],
    [ '東方', '東風谷早苗', '神霊廟', '神霊廟早苗', ],
  ],
  [
    [ 'R-18', ],
    [ 'Littlewitch', 'R-18', 'あの時はお世話になりました', 'おっぱい', '宝物', '神光臨', '聖剣のフェアリース', '芸術', ],
  ],
  [
    [ 'アイドルマスター', ],
    [ 'アイドルマスター', 'アイマス100user', '私を閉じ込めて', '雪歩', ],
  ],
  [
    [ '0_お気に入り', '東方い-犬走椛', '東方し-射命丸文', '風景', ],
    [ '射命丸文', '東方', '犬走椛', ],
  ],
  [
    [ 'Key', ],
    [ 'AIR', '水平線', '神尾観鈴', ],
  ],
  [
    [ '東方み-水橋パルスィ', ],
    [ '地霊殿', '宇治の橋姫', '東方', '水橋パルスィ', '美しい', ],
  ],
  [
    [ '東方い-伊吹萃香', '東方は-博麗霊夢', ],
    [ 'パピコ', 'パピコが幻想入り', '外の世界のお菓子', '東方', '東方Project500users入り', '萃香', '霊夢', ],
  ],
  [
    [ '' ],
    [ 'オリジナル', 'オリジナル5000users入り', 'メイキング希望', '乳神様', '尻神様', '巨乳', '水着', '神絵', '素肌が眩しい…', '金魚', ],
  ],
  [
    [ 'R-18', ],
    [ 'R-18', 'おっぱい', 'すじ', '少女', '肋骨', ],
  ],
  [
    [ '風景', ],
    [ '100点でも足りない', 'かっこいい', 'ふつくしい', 'むしろ毒を盛られたい。', 'オリジナル10000users入り', 'クリックするとこでさらに感動', 'クリック推奨', 'メイキング希望', '素敵', '魔女', ],
  ],
  [
    [ 'メカ', ],
    [ 'SAO', 'ソードアート・オンライン', 'ユウキ', ],
  ],
  [
    [ '東方や-橙', '0_お気に入り', ],
    [ 'カードゲーム', 'スペルカード', '夏鏡粋月', '幻想鏡現詩', '東方', '橙', '靴裏', ],
  ],
  [
    [ '東方は-博麗霊夢', '0_お気に入り', ],
    [ '博麗霊夢', '東方', ],
  ],
  [
    [ '東方る-ルーミア', ],
    [ 'たくし上げ', 'ルーミア', '何故かエロい中央', '東方', '眼鏡', '習作', ],
  ],
  [
    [ 'メカ', ],
    [ 'おっぱい', 'オリジナル', 'プラチナェ・・・', '乳袋', '女の子', '描いてもいいのよ', '描･･･なんという無茶ぶり', '機械', ],
  ],
  [
    [ '化物語', ],
    [ 'なんたる色気', 'ひたぎホイホイ', 'メイキング希望', '俺の知ってる阿良々木くんと違う', '傷物語', '化物語', '化物語1000users入り', '迸る色気', '阿良々木暦', '阿良々木蕩れ', ],
  ],
  [
    [ '0_お気に入り', ],
    [ 'オリジナル', ],
  ],
  [
    [ '' ],
    [ 'オリジナル', ],
  ],
  [
    [ '0_お気に入り', 'R-18', ],
    [ 'R-18', 'ちくわ人間', 'エルッセ・スーカーパップ', 'ピンクは淫乱', 'ミルク飲み人形', 'ロリ', '前から見えるお尻', '垂れ流し', '謎の白い液体', ],
  ],
  [
    [ 'R-18', '巫女', ],
    [ 'R-18', 'おっぱい', 'カグヤ', 'ニーソ足袋', '巫女', '触手', '黒獣', '黒髪', ],
  ],
  [
    [ '巫女', 'R-18', '悪堕ち', '寄生', ],
    [ 'R-18', 'アンケートに全部の選択肢がない', 'ボテ腹', '寄生', '巫女', '悪堕ち', '続編希望', '苗床', '触手', ],
  ],
  [
    [ '巫女', ],
    [ 'するする〜っ!', 'ふつくしい', 'めだかボックス', 'めだか箱1000users入り', 'アニメ化決定!', '安心院なじみ', '影', '是非させてください', '目の保養向きのイラスト', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', '創作', '巫女', '黒髪ロング', ],
  ],
  [
    [ '巫女', '黒髪ロング', ],
    [ '巫女', '戦国大戦カードイラストコンテスト2', '美人', '黒髪ロング', ],
  ],
  [
    [ '巫女', ],
    [ 'BLOOD-C', 'BLOOD100users入り', 'なにこれかっこいい', '巫女', '日本刀', '更衣小夜', '特技:見殺し', '眼鏡', '足袋', ],
  ],
  [
    [ '巫女', '亜人', ],
    [ 'おっぱい', 'オリジナル', 'オリジナル1000users入り', 'コミティア', '女の子', '巫女', '日本刀', '銃', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', '和', '巫女', '巫女の日', '巫女祭り', '黒髪', ],
  ],
  [
    [ '巫女', ],
    [ 'BLOOD-C', 'BLOOD100users入り', 'なにこれかっこいい', '巫女装束', '日本刀', '更衣小夜', ],
  ],
  [
    [ '巫女', ],
    [ 'R-15', 'はいてない', 'オリジナル', '他のタグは任せた', '巫女', '桜乃小姫', '生えてない', '目指したのは最強という名の紐', '神風よ吹け', '重力がんばって!', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', '創作', '和', '巫女', '桜', '着物', '黒髪ロング', ],
  ],
  [
    [ '獣耳', '巫女', '涙', ],
    [ 'オリジナル', '巫女服', '狐', ],
  ],
  [
    [ '巫女', '獣耳', ],
    [ 'ふつくしい', 'キツネ', '巫女', '狐', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', 'リボン', 'ロング', '剣', '巫女', '金髪', ],
  ],
  [
    [ '巫女', ],
    [ 'そしてこの背景である', 'なにこれかわいい', 'なにこれ萌える', 'メイキング希望', '神木出雲', '青の祓魔師', '青エク1000users入り', ],
  ],
  [
    [ '巫女', ],
    [ 'けもみみ', '巫女', '巫女さん祭2011', '巫女の日', '百合', '見学自由', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', '和服', '巫女', '巫女さん祭2011', '縁側', '袴', ],
  ],
  [
    [ '巫女', ],
    [ '巫女', '巫女さん祭2011', ],
  ],
  [
    [ '巫女', ],
    [ 'うさみ巫女', 'お正月', 'オリジナル', '卯', '巫女', ],
  ],
  [
    [ '巫女', ],
    [ '巫女', '戦国大戦カードイラストコンテスト', '戦国武将', ],
  ],
  [
    [ '巫女', ],
    [ 'キツネ耳', '巫女', '巫女服', '狐耳', ],
  ],
  [
    [ '巫女', ],
    [ 'オリジナル', '巫女', ],
  ],
  [
    [ 'TYPE-MOON-セイバー', ],
    [ 'FATE', 'Fate/EXTRA', 'SABER', '《fate/extra》', '紅SABER', '赤セイバー', ],
  ],
];


model.countAll(corpus2)
model.train(2)
assert.strictEqual('R-18', model.suggest(['触手'])[0][0])
