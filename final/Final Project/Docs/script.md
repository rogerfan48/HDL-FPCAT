接下來，我們會依次介紹這些 Game State 的運作：
- GS_INIT:
    當玩家點選其中一個 Stage 進入到遊戲時，會首先進入這個 state，他會在一個 clock cycle 內 將所有的信號初始化，包括 雙方的 Instance 的 exist 調回 0，雙方塔回滿血，money歸零，等等，便進入 GS_REST。
- GS_REST:
    這是個當一輪 game operation 執行完後會停留在的 state，不做任何事，只是在等待下一輪的開始，也就是當 clk_6 且 line_cnt 到達 Blanking Time 且 pulse 的開關沒有被開啟時，才會進入一輪的更新。如此就能做到 pulse 的功能了，這個功能對資深的Battle Cat 玩家 Chia Chin 而言十分重要，他是能讓玩家停下來思考戰略的一個重要功能。
- GS_GEN_E: (Generate Enemy)
    這個 state 用來依據設計好的 Enemy Queue 來生成敵人，遊戲中有一個 game_cnt 作為整個遊戲進程的一個 counter，然後還有一個 pointer 指向即將生成的那一行，當 game_cnt 和 pointer 指向的那個 timestamp 比較的結果是已經到達需要生成的時間點，便會開始找 Enemy Instance 中有無位置能生成，若有，變會依照 Enemy_Stats Decoder 所輸出的值來生成一個新的實體，並讓 pointer 指向下一行。若八個實體都還存在，便不會生成，pointer也不會向前移動，等待下一次偵測且有位置時就會生成了。
- GS_GEN_A_D: (Generate Army Detection)
    這是一個 clock cycle 的 state，用以取得是否有要生成我方的角色(cat)，這包括了判斷是否有生成按鈕被點擊、金額是否足夠、該按鈕的CD時間是否結束。並將結果傳給下一個 game state
- GS_GEN_A_G: (Generate Army Generation)
    從上個 state 接收到是否有需要生成單位。若無，則在下個 clock cycle 變前進下一個 state。若有，則會在這個 state 依序找是否有位置能夠生成，找到位置，才會花費錢並且讓該按鈕進入 CD，若沒有找到位置，這次的生成就無效，什麼都不會發生。
- GS_ATK_E, GS_ATK_A
    這兩個 state 就是分別對每一個 角色依據他們各自所在的 character state，來做 state 更新，像是 ST_MOVE 的偵測是否要攻擊還是移動。其中，射程的判定會依靠 Pixels 的 Difference 來做判斷，如此每個角色的射程判斷起點才會相同，雙方交戰時的前後關係才會有如我們預期設計的效果。而其餘的部分已在 Chapter 4.2中描述過了，這邊就不再重述。
- GS_TOWER_D: (Tower Detection)
    類似 GS_GEN_A_D，同樣是用來判斷空氣砲的發射按鈕是否有被按下且CD時間是否已經結束，並將結果傳到下一個 state
- GS_TOWER_O: (Tower Operation)
    依序檢查 Enemy_Instance，是否有實體位置在空氣砲的射程內，若是，對他造成傷害並將其 character state 改至 ST_REPEL 以實現被擊退效果。
- GS_PURSE:
    檢查 purse level 升級按鈕是否被按下，且金額是否足夠和現在等級是否尚未到達最高，若皆符合，便扣除升級所需金額並升級 Purse Level
- GS_MONEY:
    這個 state 相當單純，依據現在的 purse level 來增加對應數量的錢。
- GS_HURT_A, GS_HURT_E:
    將這一輪更新所記錄在每個 Instance 上的 be_damaged 值扣到他們的 HP 上，並且若欲扣的值超過他的 HP，便會將其 exist 歸零，也就是該實體死亡。
- GS_FINISH:
    最後，當一輪跑完回到這個 state，若雙方任一塔的血為零，表示勝負已定，便會跳出 play scene，進入 win/lose scene，否則就進入 GS_REST 等待下一輪的更新。

至此，我們已經講解完了我們主要的遊戲流程的實作方式，接著是要說明我們如何將這些渲染到畫面上

圖同我們在 Chapter 1.2 所述，在我們用於渲染的module主要分成四個，Render_Start, Render_Menu, Render_Play, and Render_WinLose，他們分別各自計算出 pixel，而依據目前所在的 scene 去MUX出我們現在要使用的 pixel值，以下是 Renderer的 Abstract Block Diagram 和圖像化示意圖。

值得注意的是我們這裡實現 Win/Lose Scene的畫面，因為我們要保留背景還是遊戲的結束當下的畫面，因次我們實作的方式是讓 Render_WinLose 僅在中間那橫條輸出所需的 color code，並在其他沒有要做渲染的部分填充隨意一個 color code(這裡使用 #eee)，而在最後輸出到 VGA 之前，將得到是 #eee的部分改渲染原先 Play Scene 的畫面並且加上 tint 的背景變白效果，更凸顯中間的橫條以及遊戲已經結束了，這個功能就是利用將 Render_Play 輸出的 color code 在 RGB 三個數值都做增亮達成的。

另外，我們這個 Renderer 跟這學期中 Lab6 的 VGA template 有所不同，原本他是將 pixel值直接餵給 VGA output，但由於我們各個 Render Module 中都需要一定量的計算，直接用 combinational 的方式將它作為 output 會讓每次 clk_25MHz 的正緣剛開始訊號尚未穩定，故利用 register 將其值儲存，不過之前的運算所使用的 h_cnt, v_cnt 作為判斷所產出的 pixel 就會產生一個 clock delay，因此我們改動 VGA module 使其額外輸出 h_cnt_1, v_cnt_1 代表提前一個 clock cycle 的對應的 h_cnt 和 v_cnt，而同理 h_cnt_5, v_cnt_5 則代表提前五個 clock cycle 的值。

如 Figure 5.2 所示，每個 Render Module 都是利用一連串的 if-else 鏈來決定是否要輸出，對於 Static Object(也就是除了雙方Instances以外的物件)，他們都有固定的顯示範圍和色碼，故可以較為簡單的實現。
一開始，我們就直觀的將我們的想法寫出來，但在 Vivado 的 Implementation Design 的地方跳出了相當多的 Timing Issues，因此我們將計算 addr 的部分利用 Pipeline 的方式優化，一次計算一部分，經過 Pipeline 後算出的 addr 再作為 RAM(IPs) 的 addr input 來獲取該像素點的代號(利用 Python 將 PNG 轉成 coe 的代號)。
有了該物件的 pixel identification codes，整個if-else鏈其實就是由 「h_cnt_1, v_cnt_1是否在這個物件要渲染的區間之間，並且其pixel identification codes非代表透明，如此便會進入這個 if condition 並將這個 pixel ID codes 轉化為 12bit 的 VGA 輸出 color code，若任一條件不符合，便會繼續 if-else 鏈，看使否有物件要在這個 pixel 做渲染，若都沒有，就會渲染最底層的背景，像是天空、草地、欄位背景色等等
其中，因為 Pipeline 以及 餵給 RAM addr 取得其值都會有 delay，因此經過運算，我們在 pipeline 的起始處需要以 h_cnt_5, v_cnt_5 作為判斷的數值，輸出時的 pixel 才會正確地對到當下的 h_cnt, v_cnt。

對於 Static Object，我們使用三個 pipeline stage 來運算出 addr 並餵給 RAM 取值，其中的運算包括將 h_cnt_5, v_cnt_5 減去該物件的 x和y，將其值除以 scaling factor(依據不同物件，有2~4)，再將 v_cnt 乘以 圖片的 width，最後將其相加並取模，即為在那個時間點，要渲染這個色塊在這個物件中coe檔案的第幾個 color code。

要渲染實體時，我們首先遇到一個棘手的問題：要讓他能成功渲染得到特定 instance 預計要渲染的 color code，需要計算出那個時間點在這個想要渲染的這個圖中的 address，問題是，若場上有超過一個相同角色的實體出現，那麼他們就會產生兩個不同的 address 想要取得他的 color code，同理，若有三隻、四隻或更多相同的角色出現，就必須要有那麼多的 存儲圖片的 RAM 讓他能算出 color code。因此我們將原先計劃雙方都能生成16隻減半成雙方能生成8隻實體，另外，改使用 True dual-port RAM，如此能夠再減少一半存儲空間。原先我們計劃進一步的將 RAM 的 clock 改成 system 的 100MHz clk 並輪流餵入 addr 並存儲得到的 color code，如此就能再減少四倍的儲存空間，不過經過縝密的計算，發現不用再細切存儲空間也足夠，我們就沒有進一步實施這個措施。

因此我們的實作方式是四組存儲貓咪的 True dual-port RAM 和四組存儲Enemy的 True dual-port RAM，每一組負責讓兩個實體運算其 color code。

而實體的address 計算方式與 Static Object 略有小差異。我們需要算出 difference(與 Pixel Decoder 中的 D 不同，這裡的偏移量是指 在每個角色都有的六張圖中從初始點偏移到依據當前state欲渲染的那一張圖的起點的偏移量值)，他是利用額外的一個 Decoder，PicNum_By_State，將該角色的 character's state 轉化成對應的 picNum(也就是每隻角色都有六個圖片中的第幾張)，在將它乘以從 Pixel Decoder 獲取的 W 和 H。

值得注意的是，PicNum_By_State Decoder的input 不只該角色的 state，還有他的x座標 10個 bit 中 LSB數來第五個 bit當作input，這是用以決定若在 ST_MOVE，他要顯示哪一張圖片，如此當他在畫面中移動時，根據 X座標的變化，角色便能活靈活現的顯示出移動的交錯動畫。

藉由以上的這些計算，我們就能獲取每個 instances 對應該時間點的 pixel ID codes，並將這個與他們的 x,y 位置值如同 Static Object 一樣放於 if-else 鏈中，就能達成 character instances 的渲染了。

6.1
在Chapter 2中就已經展示了遊戲內的圖片以及詳述了遊戲的功能，以下是一個YouTube連結，展示了我們體驗三個 Stage 的過程，並盡可能地展示了我們遊戲所實作的特色，包括：將 Purse Level 升到滿級、發射空氣砲、召喚所有 cat、撥動暫停開關、遊戲勝利以及失敗的畫面等...

6.3
經歷了超過兩百個小時的努力，我們終於做出了這款遊戲。從遊戲的發想，到開始細思如何設計，到開始規劃 Module 的 Architecture，訂定所需要使用的 protocol，學會設定更多的 Memory Block，想辦法使用 Python 將大量的親自繪製的 png轉成coe檔案，思考要怎麼使用有效率的 clock 來實現這個遊戲的運作，到實際設計每個 game state，他們之間的邏輯，到後來實際要渲染角色時，遇到空間存不下的問題，當時無比的沮喪，還甚至想說做不出來要換做別的了，後來利用 dual-port RAM和減少實體數解決了，後來又遇到了大量的(近700處的) warning 和 critical warning 關於 time delay issue，經過學習和改進，加入 pipeline設計，成功讓這些warning 消失。
總的來說，藉由這次的Final Project，我們不只更加熟稔 Verilog 以及 Vivado，也培養了遇到新的困難和挫折，能夠繞個彎並想盡辦法解決，同時也培養了團隊合作的能力，這和單獨製作的專案不同，需要協調溝通，訂定好各個模組要做設麼，資料怎麼儲存怎麼傳遞，並且也更加熟練了 Github的使用。
總之，我們投入大量精力在這個 Project上，也收穫了很多！

