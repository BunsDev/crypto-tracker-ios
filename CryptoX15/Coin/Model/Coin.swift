//
//  Coin.swift
//  Crypto
//
//  Created by CJ on 7/13/23.
//

import Foundation

/// A struct that represents a cryptocurrency coin, conforming to Decodable, Identifiable and Hashable protocols.
struct Coin: Codable, Identifiable, Hashable {
    let id: String?
    let symbol, name, image: String?
    let currentPrice, marketCap, marketCapRank: Double?
    let totalVolume: Double?
    let high24H, low24H, priceChange24H, priceChangePercentage24H: Double?
    let marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply: Double?
    let ath, athChangePercentage: Double?
    let atl, atlChangePercentage: Double?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    
    init(id: String? = nil, symbol: String? = nil, name: String? = nil, image: String? = nil, currentPrice: Double? = nil, marketCap: Double? = nil, marketCapRank: Double? = nil, totalVolume: Double? = nil, high24H: Double? = nil, low24H: Double? = nil, priceChange24H: Double? = nil, priceChangePercentage24H: Double? = nil, marketCapChange24H: Double? = nil, marketCapChangePercentage24H: Double? = nil, circulatingSupply: Double? = nil, totalSupply: Double? = nil, maxSupply: Double? = nil, ath: Double? = nil, athChangePercentage: Double? = nil, atl: Double? = nil, atlChangePercentage: Double? = nil, lastUpdated: String? = nil, sparklineIn7D: SparklineIn7D? = nil) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.lastUpdated = lastUpdated
        self.sparklineIn7D = sparklineIn7D
    }
    
    // MARK: - SparklineIn7D
    /// A structure that represents the price sparkline of a cryptocurrency in the last 7 days.
    struct SparklineIn7D: Codable, Hashable {
        let price: [Double]
        var min7D: Double {
            price.min() ?? 0
        }
        var max7D: Double {
            price.max() ?? 0
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
}

extension Coin {
    var idString: String {
        id ?? ""
    }
    
    var symbolString: String {
        symbol?.uppercased() ?? ""
    }
    
    var nameString: String {
        name ?? ""
    }
    
    var imageURLString: String {
        image ?? ""
    }
    
    var currentPriceDouble: Double {
        currentPrice ?? 0.0
    }
    
    var currentPriceString: String {
        currentPrice?.asCurrencyWithDecimals() ?? "-"
    }
    
    var marketCapString: String {
        marketCap?.asCurrencyWithDecimals() ?? "-"
    }
    var marketCapRankDouble: Double {
        marketCapRank ?? 0.0
    }
    var marketCapRankString: String {
        String(format: "%.0f", marketCapRank ?? "-")
    }
    var totalVolumeString: String {
        String(format: "%.0f", totalVolume ?? "-")
    }
    var circulatingSupplyString: String {
        String(format: "%.0f", circulatingSupply ?? "-")
    }
    var totalSupplyString: String {
        String(format: "%.0f", totalSupply ?? "-")
    }
    var maxSupplyString: String {
        String(format: "%.0f", maxSupply ?? "-")
    }
    var high24HString: String {
        high24H?.asCurrencyWithDecimals() ?? "-"
    }
    var low24HString: String {
        low24H?.asCurrencyWithDecimals() ?? "-"
    }
    var priceChange24HDouble: Double {
        priceChange24H ?? 0.0
    }
    var priceChange24HString: String {
        priceChange24H?.asCurrencyWithPrefix() ?? "-"
    }
    var priceChangePercentage24HDouble: Double {
        priceChangePercentage24H ?? 0.0
    }
    var priceChangePercentage24HString: String {
        priceChangePercentage24H?.asPercentWithPrefix() ?? "-"
    }
    var marketCapChange24HString: String {
        marketCapChange24H?.asCurrencyWithPrefix() ?? "-"
    }
    var marketCapChangePercentage24HString: String {
        marketCapChangePercentage24H?.asPercentWithPrefix() ?? "-"
    }
    var unwrappedSparklineIn7D: SparklineIn7D {
        sparklineIn7D ?? SparklineIn7D(price: [0.0])
    }
    var athString: String {
        ath?.asCurrencyWithDecimals() ?? "-"
    }
    var atlString: String {
        atl?.asCurrencyWithDecimals() ?? "-"
    }
    var endDate: Date {
        lastUpdated?.asDateFormat() ?? Date()
    }
    var startDate: Date {
        endDate.addingTimeInterval(-7*24*3600)
    }
    
    /// A test example the 'Coin' struct.
    static let testExample = Coin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
        currentPrice: 19056.16,
        marketCap: 365399969447,
        marketCapRank: 1,
        totalVolume: 23612196973,
        high24H: 19311.28,
        low24H: 18951.94,
        priceChange24H: -233.32455717016273,
        priceChangePercentage24H: -1.20959,
        marketCapChange24H: -4643394176.343018,
        marketCapChangePercentage24H: -1.25482,
        circulatingSupply: 19184156,
        totalSupply: 21000000,
        maxSupply: 21000000,
        ath: 69045,
        athChangePercentage: -72.42525,
        atl: 67.81,
        atlChangePercentage: 27977.27725,
        lastUpdated:"2022-10-20T03:53:19.454Z",
        sparklineIn7D: SparklineIn7D(price: [19152.894115946925,19142.083282468786,19104.06923230991,19069.122556127437,19091.685527894424,19088.43394166963,19102.07282164791,19052.79146011756,19000.771852818132,19013.98771232447,18971.82673690142,18668.43800740156,18738.263946389867,18372.467618415467,18446.249615209843,18549.44265006655,18956.623314261615,19134.293272681512,19162.663441529963,19345.901532300853,19375.0203223811,19397.389414660393,19417.047285905723,19416.431533390813,19387.465655359778,19427.734142614256,19872.748771742114,19805.44241393039,19823.376419821096,19813.481685955197,19821.016580012627,19806.69659633123,19647.43647008476,19608.08701544435,19636.059682552885,19673.63445597292,19626.356692909318,19781.891386388746,19637.695106066705,19458.010823013457,19371.36102851284,19312.78233347125,19353.72195104118,19198.915511839783,19223.57423056235,19185.19560060955,19117.960836598,19154.821364062154,19194.643188187696,19191.380029580385,19185.36217018641,19191.564672626537,19204.30682173264,19189.26628490064,19174.704931240896,19169.195344893793,19161.585767515764,19106.192369174474,19107.401071335673,19148.979193562485,19155.117811593547,19182.69153042117,19126.116118137073,19147.511212753012,19133.660229066776,19130.72198492508,19109.447580075503,19128.201866565036,19101.504982458206,19095.300858664385,19074.771421880847,19072.122652041628,19072.780513358884,19126.552320075007,19149.61908538506,19119.86185208045,19123.185811934487,19142.80280327335,19146.540336102124,19132.776972301806,19135.333208505253,19170.061536656907,19144.832244439614,19129.923892576495,19138.264616297172,19139.83923818251,19134.72402486814,19126.722216849274,19160.86332202918,19141.29630435813,19127.597696793342,19121.881237442118,19334.24835173174,19334.63933843128,19244.151692289328,19331.759403141215,19274.21494495987,19210.62602860393,19207.061038346048,19186.51353085701,19180.102975640068,19224.736974075167,19265.908824413542,19253.11945649304,19265.688323690378,19265.305089428162,19345.203573031315,19391.506330441614,19454.14655117412,19515.480952537582,19601.539194645306,19500.428455484052,19550.386605346102,19502.87364837517,19522.29765467499,19516.112024301474,19532.01873421546,19535.676712352968,19519.808748695992,19502.8226459347,19557.895548868444,19578.240035110248,19534.801987637256,19512.236061500014,19560.818934497773,19581.327311604866,19571.314125069483,19660.63009146628,19648.686598941156,19570.95963406971,19525.24955797527,19530.075989890214,19583.485984464307,19605.78678515135,19574.996941964437,19424.38026964221,19334.157621513103,19444.56501521997,19409.285535586747,19164.164338002003,19211.768955660533,19394.748764786993,19299.660936204546,19322.35726645525,19330.455739126475,19268.799180040704,19320.233263815557,19298.2960840077,19311.278545316716,19265.832314712374,19256.222601488058,19202.01103861112,19234.566771841513,19184.16892231751,19261.131557284683,19206.89094756097,19170.97549244248,19155.073043004777,19099.33660469521,19192.442514387203,19304.167081017404,19225.710705906447,19159.423654771057,19180.763203249826,19201.21055929438,19198.53195668864,19187.38291039068,19134.547783482674,19134.242664465204])
    )
}
