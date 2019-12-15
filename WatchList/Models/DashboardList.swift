//
//  DashboardList.swift
//  Marble-API-iOS
//
//  Created by Kishore Kumar on 12/4/19.
//
import Foundation

enum VisualizationSchema: String {
    case metric, segment
}

extension Panel {
    var metrics: [Agg] {
        return visState?.aggs?.filter({
            return $0.schema == VisualizationSchema.metric.rawValue
        }) ?? []
    }
    
    var buckets: [Agg] {
        return visState?.aggs?.filter({
            return $0.schema == VisualizationSchema.segment.rawValue
        }) ?? []
    }
}


// MARK: - VisualizationData
public struct DashboardList: Decodable, Mappable {
    public let dataList: [DashboardItem]
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.dataList = try container.decode([DashboardItem].self)
    }
}


// MARK: - DashboardItemElement
public struct DashboardItem: Codable {
    public let id: String
    public let type, title, dashboardItemDescription: String?
    public let panels: [Panel]?
    public let timeTo, timeFrom: String?

    enum CodingKeys: String, CodingKey {
        case id, type, title
        case dashboardItemDescription = "description"
        case panels, timeTo, timeFrom
    }
}

// MARK: - Panel
public struct Panel: Codable {
    public let embeddableConfig: EmbeddableConfig?
    public let gridData: GridData?
    public let id: String
    public let panelIndex: PanelIndex?
    public let type, version: String?
    public let sizeX, sizeY, col, row: Int?
    public let searchQueryPanel: String?
    public let visState: VisState?
    public let title: String?

    enum CodingKeys: String, CodingKey {
        case embeddableConfig, gridData, id, panelIndex, type, version
        case sizeX = "size_x"
        case sizeY = "size_y"
        case col, row, searchQueryPanel, visState, title
    }
}

// MARK: - EmbeddableConfig
public struct EmbeddableConfig: Codable {
    public let vis: Vis?
    public let sort, columns: [String]?
}

// MARK: - Vis
public struct Vis: Codable {
    public let defaultColors: [String : String]?
    public let params: VisParams?
    public let legendOpen: Bool?
}



// MARK: - VisParams
public struct VisParams: Codable {
    public let sort: Sort?

    public init(sort: Sort?) {
        self.sort = sort
    }
}

// MARK: - Sort
public struct Sort: Codable {
    public let columnIndex: Int?
    public let direction: String?
}

// MARK: - GridData
public struct GridData: Codable {
    public let h: Int?
    public let i: String?
    public let w, x, y: Int?
}

public enum PanelIndex: Codable {
    case integer(Int)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(PanelIndex.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PanelIndex"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - VisState
public struct VisState: Codable {
    public let title, type: String?
    public let params: VisStateParams?
    public let aggs: [Agg]?
    public let listeners: Listeners?
}

// MARK: - Agg
public struct Agg: Codable {
    public let id: String?
    public let enabled: Bool?
    public let type, schema: String?
    public let params: AggParams?
}

// MARK: - AggParams
public struct AggParams: Codable {
    public let field: String?
    public let size: Int?
    public let order, orderBy: String?
    public let otherBucket: Bool?
    public let otherBucketLabel: String?
    public let missingBucket: Bool?
    public let missingBucketLabel, exclude, customLabel: String?
    public let ranges: [Range]?
    public let timeRange: TimeRange?
    public let useNormalizedEsInterval: Bool?
    public let interval: Interval?
    public let timeZone: String?
    public let dropPartials: Bool?
    public let customInterval: String?
    public let minDocCount: Int?
    public let extendedBounds: Listeners?
    public let autoPrecision, isFilteredByCollar, useGeocentroid: Bool?
    public let mapZoom: Int?
    public let mapCenter: MapCenter?
    public let precision: Int?
    public let filters: [Filter]?

    enum CodingKeys: String, CodingKey {
        case field, size, order, orderBy, otherBucket, otherBucketLabel, missingBucket, missingBucketLabel, exclude, customLabel, ranges, timeRange, useNormalizedEsInterval, interval
        case timeZone = "time_zone"
        case dropPartials = "drop_partials"
        case customInterval
        case minDocCount = "min_doc_count"
        case extendedBounds = "extended_bounds"
        case autoPrecision, isFilteredByCollar, useGeocentroid, mapZoom, mapCenter, precision, filters
    }
}

// MARK: - Listeners
public struct Listeners: Codable {

    public init() {
    }
}

// MARK: - Filter
public struct Filter: Codable {
    public let input: Input?
    public let label: String?
}

// MARK: - Input
public struct Input: Codable {
    public let query: String?
}

public enum Interval: Codable {
    case double(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Double.self) {
            self = .double(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Interval.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Interval"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .double(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - MapCenter
public struct MapCenter: Codable {
    public let lon, lat: Double?
}

// MARK: - Range
public struct Range: Codable {
    public let from, to: Double?
}

// MARK: - TimeRange
public struct TimeRange: Codable {
    public let from, to, mode: String?
}

// MARK: - VisStateParams
public struct VisStateParams: Codable {
    public let addLegend, addTimeMarker, addTooltip: Bool?
    public let categoryAxes: [CategoryAx]?
    public let grid: Grid?
    public let legendPosition: String?
    public let seriesParams: [SeriesParam]?
    public let type: String?
    public let valueAxes: [ValueAx]?
    public let attachments, audio: String?
    public let containerID: PanelIndex?
    public let content, date, externalLink: String?
    public let fields: [String]?
    public let financialAmount, financialAmountCurrency, financialBalance, financialBalanceCurrency: String?
    public let financialCreditDebet, from, groupID, identity: String?
    public let identityType: String?
    public let imageHashField: String?
    public let images, iml: String?
    public let imlServer: String?
    public let language, location: String?
    public let maxDistance: Double?
    public let metaTypes: String?
    public let numberOfRowsToFetch: PanelIndex?
    public let place, priority, specifytype, subject: String?
    public let supportTypesEditors: SupportTypesEditors?
    public let to: String?
    public let typemode: Bool?
    public let urlThumbnail: String?
    public let video: String?
    public let metaField: String?
    public let metaFields: [String]?
    public let textScale: String?
    public let orientations, fromDegree, toDegree: Int?
    public let font, fontStyle, fontWeight: String?
    public let timeInterval: Int?
    public let spiral: String?
    public let minFontSize, maxFontSize: PanelIndex?
    public let metric: Metric?
    public let isDonut: Bool?
    public let perPage: Int?
    public let showPartialRows, showMeticsAtAllLevels: Bool?
    public let sort: Sort?
    public let showTotal: Bool?
    public let totalFunc: String?
    public let maxEXTReturned, maxNumOfFiltered, maxReturnedPaths, maxShortestPathLen: Int?
    public let nodeImageBaseURL: String?
    public let nodeImageProperty, query, html, timeField: String?
    public let locationField, userField: String?
    public let isDesaturated, realTime, autoFit: Bool?
    public let wms: Wms?
    public let showMetricsAtAllLevels: Bool?
    public let labels: ParamsLabels?
    public let scale, orientation: String?
    public let showLabel: Bool?
    public let colorSchema: String?
    public let heatClusterSize: Double?
    public let mapCenter: [Int]?
    public let mapType: String?
    public let mapZoom: Int?
    public let chatName, fileLocation, contentType, fontSize: String?
    public let jiraLogin, jiraPassword: String?
    public let jiraURL: String?
    public let enableHover: Bool?
    public let colorsNumber: Int?
    public let setColorRange: Bool?
    public let invertColors, percentageMode, isDisplayWarning: Bool?
    public let gauge: Gauge?
    public let controls: [Control]?
    public let updateFiltersOnChange, useTimeFilter, pinFilters: Bool?
    public let defaultStartTime, defaultTimeInterval: Int?
    public let handleNoResults: Bool?
    public let imageSearchServerURL, imageServerURL, kClosestNumber: String?
    public let maxDistanceMAX, maxDistanceMIN: Double?
    public let server: String?
    public let showSettingsUI: Bool?
    public let thumbnailServerURL: String?
    public let useLDA: Bool?
    public let heatBlur, heatMaxZoom: Int?
    public let heatMinOpacity: Double?
    public let heatRadius: Int?
    public let file, box, faceURL, spec: String?
    public let addCustomFilter: String?
    public let outlineWeight: Int?
    public let selectedJoinField: Field?
    public let selectedLayer: SelectedLayer?
    public let showAllShapes, useKeyCloak: Bool?
    public let msgID: String?

    enum CodingKeys: String, CodingKey {
        case addLegend, addTimeMarker, addTooltip, categoryAxes, grid, legendPosition, seriesParams, type, valueAxes, attachments, audio
        case containerID = "containerId"
        case content, date, externalLink, fields, financialAmount, financialAmountCurrency, financialBalance, financialBalanceCurrency, financialCreditDebet, from
        case groupID = "groupId"
        case identity, identityType, imageHashField, images, iml, imlServer, language, location, maxDistance, metaTypes, numberOfRowsToFetch, place, priority, specifytype, subject, supportTypesEditors, to, typemode, urlThumbnail, video, metaField, metaFields, textScale, orientations, fromDegree, toDegree, font, fontStyle, fontWeight, timeInterval, spiral, minFontSize, maxFontSize, metric, isDonut, perPage, showPartialRows, showMeticsAtAllLevels, sort, showTotal, totalFunc
        case maxEXTReturned = "max_ext_returned"
        case maxNumOfFiltered = "max_num_of_filtered"
        case maxReturnedPaths = "max_returned_paths"
        case maxShortestPathLen = "max_shortest_path_len"
        case nodeImageBaseURL = "node_image_base_url"
        case nodeImageProperty = "node_image_property"
        case query, html
        case timeField = "time_field"
        case locationField = "location_field"
        case userField = "user_field"
        case isDesaturated, realTime, autoFit, wms, showMetricsAtAllLevels, labels, scale, orientation, showLabel, colorSchema, heatClusterSize, mapCenter, mapType, mapZoom
        case chatName = "chat_name"
        case fileLocation = "file_location"
        case contentType = "content_type"
        case fontSize, jiraLogin, jiraPassword
        case jiraURL = "jiraUrl"
        case enableHover, colorsNumber, setColorRange, invertColors, percentageMode, isDisplayWarning, gauge, controls, updateFiltersOnChange, useTimeFilter, pinFilters, defaultStartTime, defaultTimeInterval, handleNoResults
        case imageSearchServerURL = "imageSearchServerUrl"
        case imageServerURL = "imageServerUrl"
        case kClosestNumber, maxDistanceMAX, maxDistanceMIN, server, showSettingsUI
        case thumbnailServerURL = "thumbnailServerUrl"
        case useLDA, heatBlur, heatMaxZoom, heatMinOpacity, heatRadius, file, box
        case faceURL = "faceUrl"
        case spec, addCustomFilter, outlineWeight, selectedJoinField, selectedLayer, showAllShapes, useKeyCloak
        case msgID = "msgId"
    }
}

// MARK: - CategoryAx
public struct CategoryAx: Codable {
    public let id: String?
    public let labels: CategoryAxLabels?
    public let position: String?
    public let scale: Format?
    public let show: Bool?
    public let style: Listeners?
    public let title: Title?
    public let type: String?
}

// MARK: - CategoryAxLabels
public struct CategoryAxLabels: Codable {
    public let show: Bool?
    public let truncate, rotate: Int?
    public let filter: Bool?
}

// MARK: - Format
public struct Format: Codable {
    public let type: String?
}

// MARK: - Title
public struct Title: Codable {
    public let text: String?

}

// MARK: - Control
public struct Control: Codable {
    public let id, indexPattern, fieldName, parent: String?
    public let label, type: String?
    public let options: ControlOptions?
}

// MARK: - ControlOptions
public struct ControlOptions: Codable {
    public let decimalPlaces, step: Int?
}

// MARK: - Gauge
public struct Gauge: Codable {
    public let verticalSplit, extendRange, percentageMode: Bool?
    public let gaugeType, gaugeStyle, backStyle, orientation: String?
    public let colorSchema, gaugeColorMode: String?
    public let colorsRange: [Range]?
    public let invertColors: Bool?
    public let labels: GaugeLabels?
    public let scale: GaugeScale?
    public let type: String?
    public let style: GaugeStyle?
    public let autoExtend, useRanges: Bool?
    public let minAngle: Int?
    public let maxAngle: Double?
    public let useRange: Bool?
}

// MARK: - GaugeLabels
public struct GaugeLabels: Codable {
    public let show: Bool?
    public let color: String?

}

// MARK: - GaugeScale
public struct GaugeScale: Codable {
    public let show, labels: Bool?
    public let color: String?
    public let width: Int?
}

// MARK: - GaugeStyle
public struct GaugeStyle: Codable {
    public let bgWidth, width: Double?
    public let mask, bgMask: Bool?
    public let maskBars: Int?
    public let bgFill: String?
    public let bgColor: Bool?
    public let subText: String?
    public let fontSize: PanelIndex?
    public let labelColor: Bool?
}

// MARK: - Grid
public struct Grid: Codable {
    public let categoryLines: Bool?
    public let style: GridStyle?
}

// MARK: - GridStyle
public struct GridStyle: Codable {
    public let color: String?
}

// MARK: - ParamsLabels
public struct ParamsLabels: Codable {
    public let show, values, lastLevel: Bool?
    public let truncate: Int?

    enum CodingKeys: String, CodingKey {
        case show, values
        case lastLevel = "last_level"
        case truncate
    }
}

// MARK: - Metric
public struct Metric: Codable {
    public let percentageMode: Bool?
    public let colorSchema: String?
    public let useRange: Bool?
    public let colorsRange: [Range]?
    public let invertColors: Bool?
    public let labels: GaugeLabels?
    public let style: MetricStyle?
    public let metricColorMode: String?
    public let useRanges: Bool?
}

// MARK: - MetricStyle
public struct MetricStyle: Codable {
    public let fontSize: Int?
    public let bgColor, labelColor: Bool?
    public let subText, bgFill: String?
}

// MARK: - Field
public struct Field: Codable {
    public let fieldDescription, name: String?

    enum CodingKeys: String, CodingKey {
        case fieldDescription = "description"
        case name
    }
}

// MARK: - SelectedLayer
public struct SelectedLayer: Codable {
    public let fields: [Field]?
    public let format: Format?
    public let isEMS: Bool?
    public let layerID: String?
    public let meta: Meta?
    public let name: String?
    public let url: String?

    enum CodingKeys: String, CodingKey {
        case fields, format, isEMS
        case layerID = "layerId"
        case meta, name, url
    }
}

// MARK: - Meta
public struct Meta: Codable {
    public let featureCollectionPath: String?

    enum CodingKeys: String, CodingKey {
        case featureCollectionPath = "feature_collection_path"
    }
}

// MARK: - SeriesParam
public struct SeriesParam: Codable {
    public let data: DataClass?
    public let drawLinesBetweenPoints: Bool?
    public let mode: String?
    public let show: Show?
    public let showCircles: Bool?
    public let type, valueAxis, interpolate: String?
}

// MARK: - DataClass
public struct DataClass: Codable {
    public let id, label: String?
}

public enum Show: Codable {
    case bool(Bool)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Show.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Show"))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - SupportTypesEditors
public struct SupportTypesEditors: Codable {
    public let all: [String]?
    public let audio: Audio?
    public let email: Email?
    public let financial, photo, text, video: Audio?
    public let sms: SMS?
}

// MARK: - Audio
public struct Audio: Codable {
    public let avaible, requied: [String]?
}

// MARK: - Email
public struct Email: Codable {
    public let avaible, requied: [String]?
    public let label: EmailLabel?
}

// MARK: - EmailLabel
public struct EmailLabel: Codable {
    public let date, from, to, subject: String?
    public let content, priority, attachements, place: String?
    public let location, iml, imlServer: String?
}

// MARK: - SMS
public struct SMS: Codable {
    public let avaible, requied: [String]?
    public let label: SMSLabel?

}

// MARK: - SMSLabel
public struct SMSLabel: Codable {
    public let date, from, to, content: String?
    public let groupID, chatName, fileLocation, contentType: String?
    public let imlServer, urlThumbnail: String?

    enum CodingKeys: String, CodingKey {
        case date, from, to, content
        case groupID = "groupId"
        case chatName = "chat_name"
        case fileLocation = "file_location"
        case contentType = "content_type"
        case imlServer, urlThumbnail
    }
}

// MARK: - ValueAx
public struct ValueAx: Codable {
    public let id: String?
    public let labels: ValueAxLabels?
    public let name, position: String?
    public let scale: ValueAxScale?
    public let show: Bool?
    public let style: Listeners?
    public let title: Title?
    public let type: String?
}

// MARK: - ValueAxLabels
public struct ValueAxLabels: Codable {
    public let filter: Bool?
    public let rotate: Int?
    public let show: Bool?
    public let truncate: Int?
    public let overwriteColor: Bool?
    public let color: String?
}

// MARK: - ValueAxScale
public struct ValueAxScale: Codable {
    public let mode, type: String?
    public let defaultYExtents: Bool?
}

// MARK: - Wms
public struct Wms: Codable {
    public let enabled: Bool?
    public let url: String?
    public let options: WmsOptions?
    public let selectedTmsLayer: SelectedTmsLayer?
}

// MARK: - WmsOptions
public struct WmsOptions: Codable {
    public let layers, version, format: String?
    public let transparent: Bool?
    public let styles, attribution: String?
}

// MARK: - SelectedTmsLayer
public struct SelectedTmsLayer: Codable {
    public let attribution, id: String?
    public let maxZoom, minZoom: Int?
    public let url: String?
}
