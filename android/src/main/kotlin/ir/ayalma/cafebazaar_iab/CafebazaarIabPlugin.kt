package ir.ayalma.cafebazaar_iab

import android.content.Intent
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import ir.ayalma.cafebazaar_iab.util.IabHelper
import ir.ayalma.cafebazaar_iab.util.Inventory
import ir.ayalma.cafebazaar_iab.util.Purchase


class CafebazaarIabPlugin(private val registrar: Registrar) : MethodCallHandler, PluginRegistry.ActivityResultListener {

    private val channel = MethodChannel(registrar.messenger(), CAFEBAZAAR_IAB)
    private var iabHelper: IabHelper? = null
    private val gson = GsonBuilder().create()

    init {
        channel.setMethodCallHandler(this)
        registrar.addActivityResultListener(this)
    }


    override fun onMethodCall(call: MethodCall, result: Result) =
            when {
                call.method == INIT -> init(call, result)
                call.method == DISPOSE -> dispose(result)
                call.method == QUERY_INVENTORY_ASYNC -> queryInventoryAsync(call, result)
                call.method == LAUNCH_PURCHASE_FLOW -> launchPurchaseFlow(call, result)
                call.method == CONSUME_ASYNC->consumeAsync(call,result)
                call.method == CONSUME_MULTI_ASYNC->consumeMultiAsync(call,result)
                else -> result.notImplemented()
            }

    /**
     * init method
     * */
    private fun init(call: MethodCall, result: Result) {
        val args = call.arguments as ArrayList<String>
        val publicKey = args[0]
        try {
            iabHelper = IabHelper(registrar.context(), publicKey)
            iabHelper?.startSetup {
                channel.invokeMethod(ON_IAB_SETUP_FINISHED, gson.toJson(it))
            }
        } catch (ex: Exception) {
            result.error(ex.message, ex.cause.toString(), ex)
        }
        result.success(true)
    }


    private fun dispose(result: Result) {
        iabHelper?.dispose()
        iabHelper = null
        result.success(true)
    }

    private fun queryInventoryAsync(call: MethodCall, methodResult: Result) {
        var args = call.arguments as ArrayList<*>
        var querySkuDetails = args[0] as Boolean
        var moreSkus = args[1] as? ArrayList<String>
        
        iabHelper?.flagEndAsync()
        iabHelper?.queryInventoryAsync(querySkuDetails, moreSkus) { result, inv: Inventory? ->
            channel.invokeMethod(QUERY_INVENTORY_FINISHED, arrayListOf<String>(gson.toJson(result), gson.toJson(inv)))
        }
        methodResult.success(true)
    }

    private fun launchPurchaseFlow(call: MethodCall, methodResult: Result) {
        val args = call.arguments as ArrayList<*>
        val sku = args[0] as String
        val payload = args[1] as String
        
        iabHelper?.flagEndAsync()
        iabHelper?.launchPurchaseFlow(registrar.activity(), sku, PURCHASE_REQUEST_CODE, { result, info ->
            channel.invokeMethod(ON_IAB_PURCHASE_FINISHED, arrayListOf<String>(gson.toJson(result), gson.toJson(info)))
        }, payload)
        methodResult.success(true)
    }

    private fun consumeAsync(call: MethodCall, methodResult: Result) {

        var purchase = gson.fromJson(call.arguments as String,Purchase::class.java)

        iabHelper?.flagEndAsync()
        iabHelper?.consumeAsync(purchase) { purchaseResult, result ->
            channel.invokeMethod(ON_CONSUME_FINISHED, arrayListOf<String>(gson.toJson(result), gson.toJson(purchaseResult)))
        }
        methodResult.success(true)
    }

    private fun consumeMultiAsync(call: MethodCall, result: Result) {
        val type = object : TypeToken<List<Purchase>>() {}
        var purchases: List<Purchase> = gson.fromJson(call.arguments as String, type.type)

        iabHelper?.flagEndAsync()
        iabHelper?.consumeAsync(purchases) { purchasesResult, results ->
            channel.invokeMethod(ON_CONSUME_MULTI_FINISHED, arrayListOf<String>(gson.toJson(results), gson.toJson(purchasesResult)))
        }
        result.success(true)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        if (requestCode == PURCHASE_REQUEST_CODE) {
            return iabHelper?.handleActivityResult(requestCode, resultCode, data) ?: true
        }
        return true
    }

    companion object {
        private const val CAFEBAZAAR_IAB = "cafebazaar_iab"
        private const val INIT = "cb_iab_init"
        private const val DISPOSE = "cb_iab_dispose"
        private const val QUERY_INVENTORY_ASYNC = "cb_iab_queryInventoryAsync"
        private const val ON_IAB_SETUP_FINISHED = "cb_iab_onIabSetupFinished"
        private const val QUERY_INVENTORY_FINISHED = "cb_iab_onQueryInventoryFinished"
        private const val LAUNCH_PURCHASE_FLOW = "cb_iab_launchPurchaseFlow"
        private const val ON_IAB_PURCHASE_FINISHED =
                "cb_iab_onIabPurchaseFinished"

        private const val CONSUME_MULTI_ASYNC =
                "cb_iab_consumeMultiAsync"
        private const val ON_CONSUME_MULTI_FINISHED =
                "cb_iab_OnConsumeMultiFinishedListener"

        private const val CONSUME_ASYNC =
                "cb_iab_consumeAsync"
        private const val ON_CONSUME_FINISHED =
                "cb_iab_OnConsumeFinishedListener"

        private const val PURCHASE_REQUEST_CODE = 10001

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            var plugin = CafebazaarIabPlugin(registrar)
        }
    }
}
