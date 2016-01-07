---

layout: post
title:  "Android 自定义 AsyncLoader loadInBackground  不被调用"
date:   2015-06-08 21:16:00
categories: [Android]
tags: [android, loader]

---
这是因为Android内部的运行方法中并不会主动调用loadInBackground()方法，所以需要手动调用forceLoad()方法，forceLoad()方法中会去调用loadInBackground()方法。

所以正确的实现应该是应该重载AsyncLoader中的onStartLoading()方法,并调用forceLoad()方法。

~~~
@Override
protected void onStartLoading() {
    forceLoad();
    super.onStartLoading();
}
~~~

完整代码如下：

~~~ Java
import android.content.AsyncTaskLoader;
import android.content.Context;

public class MyLoader extends AsyncTaskLoader<String> {

    public MyLoader(Context context) {
        super(context);
    }

    @Override
    public String loadInBackground() {
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        return new String("data");
    }

    @Override
    protected void onStartLoading() {
        forceLoad();
        super.onStartLoading();
    }

}
~~~

~~~ Java
import android.app.Activity;
import android.app.LoaderManager.LoaderCallbacks;
import android.content.Loader;
import android.os.Bundle;
import android.util.Log;

public class MainActivity extends Activity implements LoaderCallbacks<String> {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        getLoaderManager().initLoader(0, null, this);
    }

    @Override
    public Loader<String> onCreateLoader(int id, Bundle args) {
        return new MyLoader(this);
    }

    @Override
    public void onLoadFinished(Loader<String> loader, String data) {
        Log.d("MainActivity", data);
    }

    @Override
    public void onLoaderReset(Loader<String> loader) {
    }

}
~~~
